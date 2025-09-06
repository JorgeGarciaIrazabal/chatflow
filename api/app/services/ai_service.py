from typing import AsyncGenerator, Optional, List, Dict, Any, Iterable
import asyncio
import json
from openai import AsyncOpenAI
import google.generativeai as genai
from openai.types.chat import ChatCompletionMessageParam

from app.core.config import settings
from app.schemas.conversation import AIResponse, MCPToolCall, ResponseType


class AIService:
    def __init__(self):
        self.openai_client = None
        self.gemini_client = None

        self.openai_client = AsyncOpenAI(
            base_url=str(settings.OPENAI_BASE_URL), api_key=settings.OPENAI_API_KEY
        )

    async def generate_response(
        self, messages: Iterable[ChatCompletionMessageParam]
    ) -> AsyncGenerator[AIResponse, None]:
        """Generate AI response with streaming support"""
        # Try OpenAI first if available
        if self.openai_client:
            async for chunk in self._generate_openai_response(messages):
                yield chunk
            return

    async def _generate_openai_response(
        self,
        messages: Iterable[ChatCompletionMessageParam],
    ) -> AsyncGenerator[AIResponse, None]:
        """Generate response using OpenAI API"""
        try:
            response = await self.openai_client.chat.completions.create(
                model=settings.LLM_MODEL, messages=messages, stream=True
            )

            content = ""
            async for chunk in response:
                if chunk.choices[0].delta.content:
                    delta = chunk.choices[0].delta.content
                    content += delta
                    yield AIResponse(content=delta, response_type=ResponseType.TEXT)

            # Final complete response
            yield AIResponse(
                content=content, response_type=ResponseType.TEXT, is_complete=True
            )

        except Exception as e:
            yield AIResponse(
                content=f"Error generating response: {str(e)}",
                response_type=ResponseType.ERROR,
                is_complete=True,
            )

    def detect_tool_calls(self, content: str) -> Optional[List[MCPToolCall]]:
        """Detect MCP tool calls in AI response content"""
        # This is a placeholder implementation
        # In a real implementation, you would use function calling or tool use detection
        # from the AI provider's response

        # Simple pattern matching for demonstration
        if "calculate" in content.lower() and any(
            op in content for op in ["+", "-", "*", "/"]
        ):
            return [
                MCPToolCall(
                    tool_name="calculator",
                    parameters={"expression": "2+2"},  # Simplified for demo
                )
            ]

        return None


# Global AI service instance
ai_service = AIService()
