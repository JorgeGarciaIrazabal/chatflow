import 'package:equatable/equatable.dart';
import 'package:chatflow/src/core/models/message_model.dart';
import 'package:chatflow/src/core/models/conversation_model.dart';

sealed class ChatState extends Equatable {
  final List<MessageResponse> messages;
  final List<ConversationResponse> conversations;
  final int? selectedConversationId;
  final bool isLoading;

  const ChatState({
    this.messages = const [],
    this.conversations = const [],
    this.selectedConversationId,
    this.isLoading = false,
  });

  @override
  List<Object?> get props => [
        messages,
        conversations,
        selectedConversationId,
        isLoading,
      ];
}

class ChatInitial extends ChatState {
  const ChatInitial() : super();
}

class ChatLoading extends ChatState {
  const ChatLoading({
    super.messages = const [],
    super.conversations = const [],
    super.selectedConversationId,
    super.isLoading = true,
  });
}

class ChatLoaded extends ChatState {
  const ChatLoaded({
    required List<MessageResponse> messages,
    required List<ConversationResponse> conversations,
    int? selectedConversationId,
    bool isLoading = false,
  }) : super(
          messages: messages,
          conversations: conversations,
          selectedConversationId: selectedConversationId,
          isLoading: isLoading,
        );
}

class ChatError extends ChatState {
  final String message;

  const ChatError({
    required this.message,
    List<MessageResponse> messages = const [],
    List<ConversationResponse> conversations = const [],
    int? selectedConversationId,
    bool isLoading = false,
  }) : super(
          messages: messages,
          conversations: conversations,
          selectedConversationId: selectedConversationId,
          isLoading: isLoading,
        );

  @override
  List<Object?> get props => [message, ...super.props];
}
