import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'message_model.g.dart';

enum MessageRole {
  user,
  assistant,
  system,
  function,
}

enum ResponseType {
  text,
  error,
  audio,
  image,
  form,
  action,
}

@JsonSerializable()
class MessageResponse extends Equatable {
  final String content;
  final MessageRole role;
  final ResponseType responseType;
  final Map<String, dynamic>? responseMetadata;
  final int id;
  final int conversationId;
  final int? userId;
  final String? mcpToolUsed;
  final Map<String, dynamic>? mcpResponse;
  final DateTime createdAt;

  const MessageResponse({
    required this.content,
    this.role = MessageRole.user,
    this.responseType = ResponseType.text,
    this.responseMetadata,
    required this.id,
    required this.conversationId,
    this.userId,
    this.mcpToolUsed,
    this.mcpResponse,
    required this.createdAt,
  });

  factory MessageResponse.fromJson(Map<String, dynamic> json) =>
      _$MessageResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MessageResponseToJson(this);

  @override
  List<Object?> get props => [
        content,
        role,
        responseType,
        responseMetadata,
        id,
        conversationId,
        userId,
        mcpToolUsed,
        mcpResponse,
        createdAt,
      ];
}
