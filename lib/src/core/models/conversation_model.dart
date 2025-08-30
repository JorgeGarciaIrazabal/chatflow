import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:chatflow/src/core/models/message_model.dart';

part 'conversation_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ConversationResponse extends Equatable {
  final String? title;
  final int id;
  final int userId;
  final bool isActive;
  final List<int> participants;
  final List<Map<String, dynamic>> aiAgents;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<MessageResponse> messages;

  const ConversationResponse({
    this.title,
    required this.id,
    required this.userId,
    required this.isActive,
    this.participants = const [],
    this.aiAgents = const [],
    required this.createdAt,
    required this.updatedAt,
    this.messages = const [],
  });

  factory ConversationResponse.fromJson(Map<String, dynamic> json) =>
      _$ConversationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ConversationResponseToJson(this);

  @override
  List<Object?> get props => [
        title,
        id,
        userId,
        isActive,
        participants,
        aiAgents,
        createdAt,
        updatedAt,
        messages,
      ];
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ChatRequest extends Equatable {
  final String message;
  final int? conversationId;
  final bool stream;

  const ChatRequest({
    required this.message,
    this.conversationId,
    this.stream = true,
  });

  factory ChatRequest.fromJson(Map<String, dynamic> json) =>
      _$ChatRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ChatRequestToJson(this);

  @override
  List<Object?> get props => [message, conversationId, stream];
}
