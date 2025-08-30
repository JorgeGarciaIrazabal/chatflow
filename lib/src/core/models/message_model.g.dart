// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageResponse _$MessageResponseFromJson(Map<String, dynamic> json) =>
    MessageResponse(
      content: json['content'] as String,
      role:
          $enumDecodeNullable(_$MessageRoleEnumMap, json['role']) ??
          MessageRole.user,
      responseType:
          $enumDecodeNullable(_$ResponseTypeEnumMap, json['responseType']) ??
          ResponseType.text,
      responseMetadata: json['responseMetadata'] as Map<String, dynamic>?,
      id: (json['id'] as num).toInt(),
      conversationId: (json['conversationId'] as num).toInt(),
      userId: (json['userId'] as num?)?.toInt(),
      mcpToolUsed: json['mcpToolUsed'] as String?,
      mcpResponse: json['mcpResponse'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$MessageResponseToJson(MessageResponse instance) =>
    <String, dynamic>{
      'content': instance.content,
      'role': _$MessageRoleEnumMap[instance.role]!,
      'responseType': _$ResponseTypeEnumMap[instance.responseType]!,
      'responseMetadata': instance.responseMetadata,
      'id': instance.id,
      'conversationId': instance.conversationId,
      'userId': instance.userId,
      'mcpToolUsed': instance.mcpToolUsed,
      'mcpResponse': instance.mcpResponse,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$MessageRoleEnumMap = {
  MessageRole.user: 'user',
  MessageRole.assistant: 'assistant',
  MessageRole.system: 'system',
  MessageRole.function: 'function',
};

const _$ResponseTypeEnumMap = {
  ResponseType.text: 'text',
  ResponseType.error: 'error',
  ResponseType.audio: 'audio',
  ResponseType.image: 'image',
  ResponseType.form: 'form',
  ResponseType.action: 'action',
};
