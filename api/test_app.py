#!/usr/bin/env python3
"""
Simple test script to verify the Chatflow API application
"""

import sys
import asyncio
from fastapi.testclient import TestClient

# Add the src directory to the Python path
sys.path.insert(0, "src")

from app.main import app
from app.core.database import init_db


def test_app_initialization():
    """Test that the FastAPI app initializes correctly"""
    print("Testing FastAPI app initialization...")

    client = TestClient(app)

    # Test root endpoint
    response = client.get("/")
    assert response.status_code == 200
    assert "Chatflow API is running" in response.json()["message"]
    print("✓ Root endpoint works")

    # Test health endpoint
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json()["status"] == "healthy"
    print("✓ Health endpoint works")

    # Test docs endpoint
    response = client.get("/docs")
    assert response.status_code == 200
    print("✓ Documentation endpoint works")

    print("All basic endpoint tests passed!")


def test_database_initialization():
    """Test that database initialization works"""
    print("\nTesting database initialization...")

    try:
        init_db()
        print("✓ Database initialization successful")
    except Exception as e:
        print(f"✗ Database initialization failed: {e}")
        return False

    return True


async def test_ai_service():
    """Test AI service functionality"""
    print("\nTesting AI service...")

    from app.services.ai_service import ai_service

    try:
        # Test with a simple message
        messages = [{"role": "user", "content": "Hello, how are you?"}]

        responses = []
        async for response in ai_service.generate_response(messages):
            responses.append(response)

        if responses:
            print(f"✓ AI service responded: {responses[0].content[:50]}...")
            return True
        else:
            print("✗ AI service returned no response")
            return False

    except Exception as e:
        print(f"✗ AI service test failed: {e}")
        return False


async def main():
    """Run all tests"""
    print("Running Chatflow API tests...")
    print("=" * 50)

    # Test app initialization
    test_app_initialization()

    # Test database
    db_success = test_database_initialization()

    # Test AI service
    ai_success = await test_ai_service()

    print("\n" + "=" * 50)
    print("Test Summary:")
    print(f"Application: ✓ PASS")
    print(f"Database: {'✓ PASS' if db_success else '✗ FAIL'}")
    print(f"AI Service: {'✓ PASS' if ai_success else '✗ FAIL'}")

    if db_success and ai_success:
        print("\n🎉 All tests passed! The application is ready to run.")
        print("\nTo start the server:")
        print("uvicorn src.app.main:app --reload --host 0.0.0.0 --port 8000")
    else:
        print("\n❌ Some tests failed. Please check the configuration.")
        sys.exit(1)


if __name__ == "__main__":
    asyncio.run(main())
