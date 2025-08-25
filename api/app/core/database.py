from sqlalchemy import create_engine, inspect
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from .config import settings

# Create database engine
database_url_str = str(settings.DATABASE_URL)
if database_url_str.startswith("sqlite"):
    # SQLite specific configuration
    engine = create_engine(
        database_url_str,
        connect_args={"check_same_thread": False},
        echo=settings.DEBUG
    )
else:
    # PostgreSQL configuration
    engine = create_engine(
        database_url_str,
        pool_pre_ping=True,
        pool_size=20,
        max_overflow=10,
        echo=settings.DEBUG
    )

# Create session factory
SessionLocal = sessionmaker(
    autocommit=False,
    autoflush=False,
    bind=engine
)

Base = declarative_base()


# Dependency to get database session
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


def init_db():
    """Initialize database by creating all tables and listing existing ones"""
    # Import models here to avoid circular imports
    from app.models.user import User
    from app.models.conversation import Conversation, Message
    
    # List existing tables before creation
    inspector = inspect(engine)
    existing_tables = inspector.get_table_names()
    print(f"Existing tables before creation: {existing_tables}")
    
    # Create all tables
    Base.metadata.create_all(bind=engine)
    
    # List tables after creation
    inspector = inspect(engine)
    created_tables = inspector.get_table_names()
    print(f"Tables after creation: {created_tables}")
    
    return created_tables
