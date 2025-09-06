from datetime import datetime
from typing import List

from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.responses import StreamingResponse
from sqlalchemy.orm import Session

from app.auth.service import get_current_active_user
from app.core.database import get_db
from app.models.conversation import Message
from app.models.user import User
from app.schemas.conversation import (
    ConversationResponse,
    ChatRequest,
    ChatResponseChunk,
)
from app.services.ai_service import ai_service
from app.services.conversation_service import (
    get_user_conversations,
    get_user_conversation,
    create_conversation,
    delete_conversation,
    get_conversation_messages, save_message,
)
from app.services.mcp_service import mcp_service


router = APIRouter(prefix="/conversations", tags=["conversations"])


@router.get("", response_model=List[ConversationResponse])
async def get_conversations(
    current_user: User = Depends(get_current_active_user), db: Session = Depends(get_db)
):
    """Get all conversations for the current user"""
    conversations = get_user_conversations(db, current_user)
    return conversations


@router.get("/{conversation_id}", response_model=ConversationResponse)
async def get_conversation(
    conversation_id: int,
    current_user: User = Depends(get_current_active_user),
    db: Session = Depends(get_db),
):
    """Get a specific conversation with its messages"""
    conversation = get_user_conversation(db, conversation_id, current_user)
    if not conversation:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="Conversation not found"
        )

    return conversation


@router.post("", response_model=ConversationResponse)
async def create_conversation_endpoint(
    current_user: User = Depends(get_current_active_user), db: Session = Depends(get_db)
):
    """Create a new conversation"""
    conversation = create_conversation(db, current_user)
    return conversation


@router.delete("/{conversation_id}")
async def delete_conversation_endpoint(
    conversation_id: int,
    current_user: User = Depends(get_current_active_user),
    db: Session = Depends(get_db),
):
    """Delete a conversation (soft delete)"""
    success = delete_conversation(db, conversation_id, current_user)

    if not success:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="Conversation not found"
        )

    return {"message": "Conversation deleted"}


@router.post(
    "/chat",
    responses={
        200: {
            "content": {"text/plain": {}},
            "description": f"A streaming response with JSON schema:\n{ChatResponseChunk.model_json_schema()}\nAnd separated by \\n\\n",
        }
    },
    response_class=StreamingResponse,
)
async def chat_stream(
    chat_request: ChatRequest,
    current_user: User = Depends(get_current_active_user),
    db: Session = Depends(get_db),
):
    """Send a message and get streaming AI response"""
    if chat_request.conversation_id:
        conversation = get_user_conversation(
            db, chat_request.conversation_id, current_user
        )
        if not conversation:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND, detail="Conversation not found"
            )
    else:
        conversation = create_conversation(db, current_user)
    user_message = Message(
        conversation_id=conversation.id,
        user_id=current_user.id,
        content=chat_request.message,
        role="user",
    )
    save_message(db, user_message, conversation)

    messages = get_conversation_messages(db, conversation.id)

    # Format messages for AI
    ai_messages = []
    for msg in messages:
        ai_messages.append({"role": msg.role, "content": msg.content})

    async def generate_stream():
        full_content = ""
        mcp_tool_used = None
        mcp_response = None

        async for ai_response in ai_service.generate_response(ai_messages):
            full_content += ai_response.content

            # Stream the response chunk
            yield f"{
                ChatResponseChunk(
                    content=ai_response.content,
                    response_type=ai_response.response_type,
                    metadata=ai_response.metadata,
                    is_complete=ai_response.is_complete,
                ).model_dump_json()
            }"

        # Save the complete AI response to database
        ai_message = Message(
            conversation_id=conversation.id,
            user_id=None,
            content=full_content,
            role="assistant",
            mcp_tool_used=mcp_tool_used,
            mcp_response=mcp_response,
        )
        save_message(db, ai_message, conversation)

    return StreamingResponse(
        generate_stream(),
        media_type="text/event-stream",
        headers={
            "Cache-Control": "no-cache",
            "Connection": "keep-alive",
        },
    )


@router.get("/tools/available")
async def get_available_tools():
    """Get list of available MCP tools"""
    return mcp_service.get_available_tools()
