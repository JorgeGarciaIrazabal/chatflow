import uvicorn
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from contextlib import asynccontextmanager

from app.core.database import init_db
from app.auth.endpoints import router as auth_router
from app.api.endpoints.conversation import router as conversation_router


@asynccontextmanager
async def lifespan(app: FastAPI):
    # Initialize database on startup
    init_db()
    print("Database initialized")
    yield
    # Clean up on shutdown
    print("Application shutting down")


app = FastAPI(
    title="Chatflow API",
    description="Backend API for AI chat applications with MCP integration",
    version="0.1.0",
    lifespan=lifespan,
)

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, replace with specific origins
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routers
app.include_router(auth_router)
app.include_router(conversation_router)


@app.get("/")
async def root():
    return {
        "message": "Chatflow API is running",
        "version": "0.1.0",
        "docs": "/docs",
        "redoc": "/redoc",
    }


@app.get("/health")
async def health_check():
    return {"status": "healthy", "service": "chatflow-api"}


if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
