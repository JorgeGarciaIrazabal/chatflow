import 'package:equatable/equatable.dart';
import 'package:chatflow/src/core/models/message_model.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class ChatSendMessageEvent extends ChatEvent {
  final String message;
  final ResponseType? responseType;
  final Map<String, dynamic>? metadata;

  const ChatSendMessageEvent({
    required this.message,
    this.responseType,
    this.metadata,
  });

  @override
  List<Object?> get props => [message, responseType, metadata];
}

class ChatLoadConversationsEvent extends ChatEvent {}

class ChatSelectConversationEvent extends ChatEvent {
  final int conversationId;

  const ChatSelectConversationEvent({required this.conversationId});

  @override
  List<Object?> get props => [conversationId];
}

class ChatReceiveMessageEvent extends ChatEvent {
  final MessageResponse message;

  const ChatReceiveMessageEvent({required this.message});

  @override
  List<Object?> get props => [message];
}
