// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConversationResponse _$ConversationResponseFromJson(
  Map<String, dynamic> json,
) => ConversationResponse(
  title: json['title'] as String?,
  id: (json['id'] as num).toInt(),
  userId: (json['user_id'] as num).toInt(),
  isActive: json['is_active'] as bool,
  participants:
      (json['participants'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      const [],
  aiAgents:
      (json['ai_agents'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList() ??
      const [],
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  messages:
      (json['messages'] as List<dynamic>?)
          ?.map((e) => MessageResponse.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$ConversationResponseToJson(
  ConversationResponse instance,
) => <String, dynamic>{
  'title': instance.title,
  'id': instance.id,
  'user_id': instance.userId,
  'is_active': instance.isActive,
  'participants': instance.participants,
  'ai_agents': instance.aiAgents,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
  'messages': instance.messages,
};

ChatRequest _$ChatRequestFromJson(Map<String, dynamic> json) => ChatRequest(
  message: json['message'] as String,
  conversationId: (json['conversation_id'] as num?)?.toInt(),
  stream: json['stream'] as bool? ?? true,
);

Map<String, dynamic> _$ChatRequestToJson(ChatRequest instance) =>
    <String, dynamic>{
      'message': instance.message,
      'conversation_id': instance.conversationId,
      'stream': instance.stream,
    };
