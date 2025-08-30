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
          $enumDecodeNullable(_$ResponseTypeEnumMap, json['response_type']) ??
          ResponseType.text,
      responseMetadata: json['response_metadata'] as Map<String, dynamic>?,
      id: (json['id'] as num).toInt(),
      conversationId: (json['conversation_id'] as num).toInt(),
      userId: (json['user_id'] as num?)?.toInt(),
      mcpToolUsed: json['mcp_tool_used'] as String?,
      mcpResponse: json['mcp_response'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$MessageResponseToJson(MessageResponse instance) =>
    <String, dynamic>{
      'content': instance.content,
      'role': _$MessageRoleEnumMap[instance.role]!,
      'response_type': _$ResponseTypeEnumMap[instance.responseType]!,
      'response_metadata': instance.responseMetadata,
      'id': instance.id,
      'conversation_id': instance.conversationId,
      'user_id': instance.userId,
      'mcp_tool_used': instance.mcpToolUsed,
      'mcp_response': instance.mcpResponse,
      'created_at': instance.createdAt.toIso8601String(),
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
