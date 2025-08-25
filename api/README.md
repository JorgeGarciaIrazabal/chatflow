# Chatflow API

A FastAPI backend for AI chat applications with authentication, streaming responses, and MCP (Model Context Protocol) integration.

## Features

- **Authentication**: Email/password authentication with JWT tokens
- **AI Integration**: Support for OpenAI and Google Gemini AI providers
- **Streaming Responses**: Real-time streaming of AI responses
- **MCP Integration**: Ability to call external tools via Model Context Protocol
- **Multi-type Responses**: Support for text, audio, images, forms, and actions
- **Scalable Architecture**: Designed for future multi-human, multi-AI conversations
- **Database Persistence**: SQLAlchemy with PostgreSQL support

## Quick Start

### Prerequisites

- Python 3.12+
- PostgreSQL database
- Redis (optional, for caching)
- UV package manager

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd chatflow/api
   ```

2. **Create virtual environment**
   ```bash
   uv venv --python 3.12 .venv
   source .venv/bin/activate  # On Windows: .venv\Scripts\activate
   ```

3. **Install dependencies**
   ```bash
   uv sync
   ```

4. **Environment setup**
   ```bash
   cp .env.example .env
   # Edit .env with your actual configuration
   ```

5. **Database setup**
   ```bash
   # Create PostgreSQL database named 'chatflow'
   # The application will create tables automatically on first run
   ```

6. **Run the application**
   ```bash
   uvicorn src.app.main:app --reload --host 0.0.0.0 --port 8000
   ```

## Configuration

### Environment Variables

Create a `.env` file with the following variables:

```env
# Database
DATABASE_URL=postgresql://user:password@localhost:5432/chatflow

# Redis (optional)
REDIS_URL=redis://localhost:6379/0

# JWT
JWT_SECRET_KEY=your-super-secret-jwt-key
JWT_ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30

# AI Providers (at least one required)
OPENAI_API_KEY=your-openai-api-key
GEMINI_API_KEY=your-gemini-api-key

# Application
DEBUG=True
ENVIRONMENT=development
```

### AI Provider Setup

You need at least one AI provider configured:

- **OpenAI**: Get API key from [OpenAI Platform](https://platform.openai.com)
- **Google Gemini**: Get API key from [Google AI Studio](https://makersuite.google.com)

## API Endpoints

### Authentication

- `POST /auth/register` - Register new user
- `POST /auth/login` - Login with email/password
- `POST /auth/login-json` - Login with JSON payload
- `GET /auth/me` - Get current user info

### Conversations

- `GET /conversations` - Get user conversations
- `POST /conversations` - Create new conversation
- `GET /conversations/{id}` - Get specific conversation
- `DELETE /conversations/{id}` - Delete conversation
- `POST /conversations/chat` - Send message (non-streaming)
- `POST /conversations/chat/stream` - Send message (streaming)
- `GET /conversations/tools/available` - Get available MCP tools

## Usage Examples

### Register User

```bash
curl -X POST "http://localhost:8000/auth/register" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "securepassword123",
    "full_name": "John Doe"
  }'
```

### Login

```bash
curl -X POST "http://localhost:8000/auth/login" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "username=user@example.com&password=securepassword123"
```

### Send Message (Streaming)

```bash
curl -X POST "http://localhost:8000/conversations/chat/stream" \
  -H "Authorization: Bearer <your-jwt-token>" \
  -H "Content-Type: application/json" \
  -d '{
    "message": "Hello, how are you?",
    "stream": true
  }'
```

## MCP Integration

The API supports MCP (Model Context Protocol) tool calls. Currently implemented demo tools:

- **Calculator**: Basic arithmetic operations
- **Weather**: Mock weather data (placeholder)

To add new MCP tools, update the `MCP_SERVERS` configuration in `src/app/core/config.py`.

## Project Structure

```
src/app/
├── auth/           # Authentication endpoints and services
├── models/         # Database models
├── schemas/        # Pydantic schemas
├── services/       # AI and MCP services
├── api/            # API endpoints
│   └── endpoints/  # Route handlers
├── core/           # Core configuration and database
└── main.py         # FastAPI application
```

## Development

### Code Style

This project uses:
- **Ruff** for linting and formatting
- **Pytest** for testing
- **SQLAlchemy** for database operations
- **Pydantic** for data validation

### Running Tests

```bash
uv run pytest
```

### Formatting Code

```bash
uv format
```

### Linting

```bash
uv run ruff check .
```

## Deployment

### Production Considerations

1. **Set proper JWT secret** in production environment
2. **Disable DEBUG mode**
3. **Use proper database connection pooling**
4. **Configure CORS for your frontend domain**
5. **Set up proper logging and monitoring**
6. **Use HTTPS in production**

### Docker Deployment

A sample Dockerfile can be added for containerized deployment.

## Future Enhancements

- Multi-user conversation support
- Advanced MCP server integration
- File upload and media handling
- Real-time WebSocket connections
- Advanced caching with Redis
- Rate limiting and API throttling
- Admin dashboard and analytics

## License

This project is licensed under the MIT License.
