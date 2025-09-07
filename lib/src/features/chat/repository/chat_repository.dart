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

  Stream<MessageResponse> sendMessage({
    required String message,
    int? conversationId,
  }) async* {
    try {
      final token = await authRepository.getToken();
      if (token == null) {
        throw Exception('Not authenticated');
      }

      final request = http.Request(
        'POST',
        Uri.parse('$_baseUrl/conversations/chat'),
      )
        ..headers.addAll({
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'Accept': 'text/event-stream',
        })
        ..body = json.encode({
          'message': message,
          'conversation_id': conversationId,
          'stream': true,
        });

      final client = http.Client();
      final response = await client.send(request);

      if (response.statusCode == 200) {
        final stream = response.stream
            .transform(utf8.decoder)
            .transform(const LineSplitter());

        await for (final line in stream) {
          if (line.startsWith('data:')) {
            final jsonString = line.substring(5);
            if (jsonString.isNotEmpty) {
              final data = json.decode(jsonString);
              yield MessageResponse.fromJson(data);
            }
          }
        }
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

  // Create a new conversation (no request body as per OpenAPI spec)
  Future<ConversationResponse> createConversation() async {
    try {
      final token = await authRepository.getToken();
      if (token == null) {
        throw Exception('Not authenticated');
      }

      final response = await http.post(
        Uri.parse('$_baseUrl/conversations'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ConversationResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to create conversation: ${response.statusCode}');
      }
    } catch (e, s) {
      ErrorHandlerService.handleError(e, s);
      rethrow;
    }
  }
}
