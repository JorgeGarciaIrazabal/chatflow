from datetime import datetime
from typing import List
from sqlalchemy.orm import Session

from app.models.conversation import Conversation, Message
from app.models.user import User


def get_user_conversations(db: Session, user: User) -> List[Conversation]:
    """Get all active conversations for the current user"""
    return (
        db.query(Conversation)
        .filter(Conversation.user_id == user.id, Conversation.is_active == True)
        .order_by(Conversation.updated_at.desc())
        .all()
    )


def get_user_conversation(
    db: Session, conversation_id: int, user: User
) -> Conversation:
    """Get a specific conversation for the current user"""
    return (
        db.query(Conversation)
        .filter(Conversation.id == conversation_id, Conversation.user_id == user.id)
        .first()
    )


def create_conversation(db: Session, user: User) -> Conversation:
    """Create a new conversation"""
    conversation = Conversation(user_id=user.id, title="New Conversation")

    db.add(conversation)
    db.commit()
    db.refresh(conversation)

    return conversation


def delete_conversation(db: Session, conversation_id: int, user: User) -> bool:
    """Delete a conversation (soft delete)"""
    conversation = (
        db.query(Conversation)
        .filter(Conversation.id == conversation_id, Conversation.user_id == user.id)
        .first()
    )

    if not conversation:
        return False

    conversation.is_active = False
    db.commit()
    return True


def get_conversation_messages(db: Session, conversation_id: int) -> List[Message]:
    """Get all messages for a specific conversation"""
    return (
        db.query(Message)
        .filter(Message.conversation_id == conversation_id)
        .order_by(Message.created_at.asc())
        .all()
    )


def save_message(db: Session, message: Message, conversation: Conversation) -> None:
    """Save a new message to the database"""
    db.add(message)
    # Update conversation timestamp
    conversation.updated_at = datetime.now()
    db.commit()
