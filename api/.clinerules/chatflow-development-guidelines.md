## Brief overview
This document contains development guidelines and preferences specific to the Chatflow project, focusing on scalable Python development with uv and clean code practices.

## Project structure
- Maintain a well-structured folder hierarchy that is easy to understand and navigate
- Keep files focused and not overly complex
- Use the existing src/app structure for main application code
- Virtual environments should be created in the ".venv" directory

## Code quality standards
- Functions should not exceed 20 lines of code to maintain readability
- Write scalable code that can handle growth and additional features
- Use Python type annotations throughout the codebase for better type safety
- Follow clean code principles and maintain consistent coding style

## Development tools
- Use uv for virtual environment setup and dependency management
- Leverage uv commands for project initialization, dependency management, and environment synchronization
- Utilize uv's built-in formatting capabilities with the format command
- Manage Python versions and installations using uv python command

## Workflow preferences
- Set up virtual environments using `uv venv` with target directory ".venv"
- Add dependencies using `uv add` command
- Synchronize environments with `uv sync`
- Format code using `uv format`
- Run the application using appropriate uv or Python commands

## Scalability considerations
- Design components to be modular and easily extensible
- Avoid tight coupling between different parts of the application
- Plan for future feature additions without requiring major refactoring
- Maintain clear separation of concerns between different modules
