from datetime import datetime

from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.responses import StreamingResponse
from sqlalchemy.orm import Session
from typing import List, Optional

from app.core.database import get_db
from app.models.user import User
from app.models.conversation import Conversation, Message
from app.schemas.conversation import (
    ConversationResponse,
    MessageCreate,
    MessageResponse,
    ChatRequest,
    ChatResponseChunk,
    ResponseType
)
from app.auth.service import get_current_active_user
from app.services.ai_service import ai_service
from app.services.mcp_service import mcp_service

router = APIRouter(prefix="/conversations", tags=["conversations"])


@router.get("", response_model=List[ConversationResponse])
async def get_conversations(
    current_user: User = Depends(get_current_active_user),
    db: Session = Depends(get_db)
):
    """Get all conversations for the current user"""
    conversations = db.query(Conversation).filter(
        Conversation.user_id == current_user.id,
        Conversation.is_active == True
    ).order_by(Conversation.updated_at.desc()).all()
    
    return conversations


@router.get("/{conversation_id}", response_model=ConversationResponse)
async def get_conversation(
    conversation_id: int,
    current_user: User = Depends(get_current_active_user),
    db: Session = Depends(get_db)
):
    """Get a specific conversation with its messages"""
    conversation = db.query(Conversation).filter(
        Conversation.id == conversation_id,
        Conversation.user_id == current_user.id
    ).first()
    
    if not conversation:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Conversation not found"
        )
    
    return conversation


@router.post("", response_model=ConversationResponse)
async def create_conversation(
    current_user: User = Depends(get_current_active_user),
    db: Session = Depends(get_db)
):
    """Create a new conversation"""
    conversation = Conversation(
        user_id=current_user.id,
        title="New Conversation"
    )
    
    db.add(conversation)
    db.commit()
    db.refresh(conversation)
    
    return conversation


@router.delete("/{conversation_id}")
async def delete_conversation(
    conversation_id: int,
    current_user: User = Depends(get_current_active_user),
    db: Session = Depends(get_db)
):
    """Delete a conversation (soft delete)"""
    conversation = db.query(Conversation).filter(
        Conversation.id == conversation_id,
        Conversation.user_id == current_user.id
    ).first()
    
    if not conversation:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Conversation not found"
        )
    
    conversation.is_active = False
    db.commit()
    
    return {"message": "Conversation deleted"}


@router.post("/chat")
async def chat_stream(
    chat_request: ChatRequest,
    current_user: User = Depends(get_current_active_user),
    db: Session = Depends(get_db)
):
    """Send a message and get streaming AI response"""
    # Get or create conversation
    if chat_request.conversation_id:
        conversation = db.query(Conversation).filter(
            Conversation.id == chat_request.conversation_id,
            Conversation.user_id == current_user.id
        ).first()

        if not conversation:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Conversation not found"
            )
    else:
        conversation = Conversation(
            user_id=current_user.id,
            title=chat_request.message[:50] + "..." if len(chat_request.message) > 50 else chat_request.message
        )
        db.add(conversation)
        db.commit()
        db.refresh(conversation)

    # Save user message
    user_message = Message(
        conversation_id=conversation.id,
        user_id=current_user.id,
        content=chat_request.message,
        role="user"
    )
    db.add(user_message)
    db.commit()

    # Get conversation history for context
    messages = db.query(Message).filter(
        Message.conversation_id == conversation.id
    ).order_by(Message.created_at.asc()).all()

    # Format messages for AI
    ai_messages = []
    for msg in messages:
        ai_messages.append({
            "role": msg.role,
            "content": msg.content
        })

    async def generate_stream():
        full_content = ""
        mcp_tool_used = None
        mcp_response = None

        async for ai_response in ai_service.generate_response(ai_messages):
            full_content += ai_response.content

            # Stream the response chunk
            yield f"data: {ChatResponseChunk(
                content=ai_response.content,
                response_type=ai_response.response_type,
                metadata=ai_response.metadata,
                is_complete=ai_response.is_complete
            ).model_dump_json()}\n\n"


        # Save the complete AI response to database
        ai_message = Message(
            conversation_id=conversation.id,
            user_id=None,
            content=full_content,
            role="assistant",
            mcp_tool_used=mcp_tool_used,
            mcp_response=mcp_response
        )
        db.add(ai_message)

        # Update conversation timestamp
        conversation.updated_at = datetime.now()
        db.commit()

    return StreamingResponse(
        generate_stream(),
        media_type="text/event-stream",
        headers={
            "Cache-Control": "no-cache",
            "Connection": "keep-alive",
        }
    )


@router.get("/tools/available")
async def get_available_tools():
    """Get list of available MCP tools"""
    return mcp_service.get_available_tools()
