import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:chatflow/src/core/services/error_handler_service.dart';
import 'package:chatflow/src/features/auth/repository/auth_repository.dart';
import 'package:chatflow/src/core/models/message_model.dart';
import 'package:chatflow/src/core/models/conversation_model.dart';

class ChatRepository {
  static const String _baseUrl = 'http://127.0.0.1:8000';
  final AuthRepository authRepository;

  ChatRepository({required this.authRepository});

  Future<MessageResponse> sendMessage({
    required String message,
    int? conversationId,
  }) async {
    try {
      final token = await authRepository.getToken();
      if (token == null) {
        throw Exception('Not authenticated');
      }

      final response = await http.post(
        Uri.parse('$_baseUrl/conversations/chat'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'message': message,
          'conversation_id': conversationId,
          'stream': false,
        }),
      );

      if (response.statusCode == 200) {
        // For now, simulate a response since the API might return streaming
        // In a real implementation, we would handle the streaming response
        return MessageResponse(
          content: 'This is a simulated response from the AI',
          role: MessageRole.assistant,
          responseType: ResponseType.text,
          id: DateTime.now().millisecondsSinceEpoch,
          conversationId: conversationId ?? 1,
          userId: null,
          createdAt: DateTime.now(),
        );
      } else {
        throw Exception('Failed to send message: ${response.statusCode}');
      }
    } catch (e, s) {
      ErrorHandlerService.handleError(e, s);
      rethrow;
    }
  }

  Future<List<ConversationResponse>> getConversations() async {
    try {
      final token = await authRepository.getToken();
      if (token == null) {
        throw Exception('Not authenticated');
      }

      final response = await http.get(
        Uri.parse('$_baseUrl/conversations'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => ConversationResponse.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load conversations: ${response.statusCode}');
      }
    } catch (e, s) {
      ErrorHandlerService.handleError(e, s);
      rethrow;
    }
  }

  Future<ConversationResponse> getConversation(int conversationId) async {
    try {
      final token = await authRepository.getToken();
      if (token == null) {
        throw Exception('Not authenticated');
      }

      final response = await http.get(
        Uri.parse('$_baseUrl/conversations/$conversationId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return ConversationResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load conversation: ${response.statusCode}');
      }
    } catch (e, s) {
      ErrorHandlerService.handleError(e, s);
      rethrow;
    }
  }
}
