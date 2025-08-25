from pydantic import BaseModel, Field
from typing import Optional, List, Dict, Any
from datetime import datetime
from enum import Enum


class MessageRole(str, Enum):
    USER = "user"
    ASSISTANT = "assistant"
    SYSTEM = "system"
    FUNCTION = "function"


class ResponseType(str, Enum):
    TEXT = "text"
    ERROR = "error"
    AUDIO = "audio"
    IMAGE = "image"
    FORM = "form"
    ACTION = "action"


class MessageBase(BaseModel):
    content: str
    role: MessageRole = MessageRole.USER
    response_type: ResponseType = ResponseType.TEXT
    response_metadata: Optional[Dict[str, Any]] = None


class MessageCreate(MessageBase):
    conversation_id: Optional[int] = None  # If None, creates new conversation


class MessageResponse(MessageBase):
    id: int
    conversation_id: int
    user_id: Optional[int]
    mcp_tool_used: Optional[str] = None
    mcp_response: Optional[Dict[str, Any]] = None
    created_at: datetime

    class Config:
        from_attributes = True


class ConversationBase(BaseModel):
    title: Optional[str] = None


class ConversationCreate(ConversationBase):
    pass


class ConversationResponse(ConversationBase):
    id: int
    user_id: int
    is_active: bool
    participants: List[int] = []
    ai_agents: List[Dict[str, Any]] = []
    created_at: datetime
    updated_at: datetime
    messages: List[MessageResponse] = []

    class Config:
        from_attributes = True


class ChatRequest(BaseModel):
    message: str
    conversation_id: Optional[int] = None
    stream: bool = True


class ChatResponseChunk(BaseModel):
    content: str
    response_type: ResponseType = ResponseType.TEXT
    metadata: Optional[Dict[str, Any]] = None
    mcp_tool_used: Optional[str] = None
    is_complete: bool = False


class MCPToolCall(BaseModel):
    tool_name: str
    parameters: Dict[str, Any]


class AIResponse(BaseModel):
    content: str
    response_type: ResponseType = ResponseType.TEXT
    metadata: Optional[Dict[str, Any]] = None
    tool_calls: Optional[List[MCPToolCall]] = None
    is_complete: bool = False
