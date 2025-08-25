from pydantic import Field, RedisDsn, AnyUrl
from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    OPENAI_BASE_URL: AnyUrl = Field(
        default="https://localhost:1234"
    )
    OPENAI_API_KEY: str = Field(default="no_key")

    # Database
    DATABASE_URL: AnyUrl = Field(
        default="sqlite:///./chatflow.db"
    )
    
    # Redis for caching and sessions
    REDIS_URL: RedisDsn = Field(
        default="redis://localhost:6379/0"
    )
    
    # JWT
    JWT_SECRET_KEY: str = Field(
        default="your-secret-key-change-in-production",
        description="Secret key for JWT token generation"
    )
    JWT_ALGORITHM: str = Field(default="HS256")
    ACCESS_TOKEN_EXPIRE_MINUTES: int = Field(default=30)
    
    # MCP Configuration
    MCP_SERVERS: dict = Field(
        default_factory=lambda: {}
    )
    
    # Application
    DEBUG: bool = Field(default=False)
    ENVIRONMENT: str = Field(default="development")
    
    class Config:
        env_file = ".env"
        case_sensitive = True


settings = Settings()
