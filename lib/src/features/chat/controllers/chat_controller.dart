import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:chatflow/src/core/models/message_model.dart';
import 'package:chatflow/src/core/models/conversation_model.dart';
import 'package:chatflow/src/core/services/error_handler_service.dart';
import 'package:chatflow/src/features/chat/repository/chat_repository.dart';

class ChatController extends ChangeNotifier {
  final ChatRepository chatRepository;
  
  List<MessageResponse> _messages = [];
  List<ConversationResponse> _conversations = [];
  int? _selectedConversationId;
  bool _isLoading = false;
  String? _errorMessage;

  ChatController({required this.chatRepository});

  // Getters
  List<MessageResponse> get messages => _messages;
  List<ConversationResponse> get conversations => _conversations;
  int? get selectedConversationId => _selectedConversationId;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    _errorMessage = null;
    notifyListeners();
  }

  // Set error state
  void _setError(String message) {
    _isLoading = false;
    _errorMessage = message;
    notifyListeners();
  }

  // Send message
  Future<void> sendMessage(String message) async {
    if (_selectedConversationId == null) {
      _setError('No conversation selected');
      return;
    }

    _setLoading(true);

    try {
      // Add user message to the state immediately for better UX
      final userMessage = MessageResponse(
        content: message,
        role: MessageRole.user,
        responseType: ResponseType.text,
        id: DateTime.now().millisecondsSinceEpoch,
        conversationId: _selectedConversationId!,
        userId: null,
        createdAt: DateTime.now(),
      );

      _messages = [..._messages, userMessage];
      notifyListeners();

      // Send message to API and get response
      final response = await chatRepository.sendMessage(
        message: message,
        conversationId: _selectedConversationId,
      );

      // Add AI response to messages
      _messages = [..._messages, response];
      _isLoading = false;
      notifyListeners();
    } catch (e, s) {
      ErrorHandlerService.handleError(e, s);
      _setError(e.toString());
    }
  }

  // Load conversations
  Future<void> loadConversations() async {
    _setLoading(true);

    try {
      _conversations = await chatRepository.getConversations();
      _isLoading = false;
      notifyListeners();
    } catch (e, s) {
      ErrorHandlerService.handleError(e, s);
      _setError(e.toString());
    }
  }

  // Select conversation
  Future<void> selectConversation(int conversationId) async {
    _setLoading(true);
    _selectedConversationId = conversationId;

    try {
      final conversation = await chatRepository.getConversation(conversationId);
      _messages = conversation.messages;
      _isLoading = false;
      notifyListeners();
    } catch (e, s) {
      ErrorHandlerService.handleError(e, s);
      _setError(e.toString());
    }
  }

  // Add message (for receiving messages from external sources)
  void addMessage(MessageResponse message) {
    _messages = [..._messages, message];
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
