from sqlalchemy import Column, Integer, String, DateTime, ForeignKey, Boolean, JSON, func
from sqlalchemy.orm import relationship
from datetime import datetime
from typing import Optional, List
from .user import Base


class Conversation(Base):
    __tablename__ = "conversations"

    id = Column(Integer, primary_key=True, index=True)
    title = Column(String, nullable=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime, default=func.now())
    updated_at = Column(DateTime, default=func.now(), onupdate=func.now())
    
    # For future multi-participant support
    participants = Column(JSON, default=[])  # List of user IDs
    ai_agents = Column(JSON, default=[])     # List of AI agent configurations
    
    # Relationships
    user = relationship("User", back_populates="conversations")
    messages = relationship("Message", back_populates="conversation", cascade="all, delete-orphan")

    def __repr__(self):
        return f"<Conversation(id={self.id}, title={self.title})>"


class Message(Base):
    __tablename__ = "messages"

    id = Column(Integer, primary_key=True, index=True)
    conversation_id = Column(Integer, ForeignKey("conversations.id"), nullable=False)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=True)  # Null for AI messages
    content = Column(String, nullable=False)
    role = Column(String, nullable=False)  # "user", "assistant", "system", "function"
    
    # For multi-type responses
    response_type = Column(String, default="text")  # "text", "audio", "image", "form", "action"
    response_metadata = Column(JSON, default={})  # Additional data for different response types
    
    # For MCP integration
    mcp_tool_used = Column(String, nullable=True)
    mcp_response = Column(JSON, nullable=True)
    
    created_at = Column(DateTime, default=func.now())
    
    # Relationships
    conversation = relationship("Conversation", back_populates="messages")
    user = relationship("User", back_populates="messages")

    def __repr__(self):
        return f"<Message(id={self.id}, role={self.role}, type={self.response_type})>"
