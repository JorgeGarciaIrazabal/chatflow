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
  userId: (json['userId'] as num).toInt(),
  isActive: json['isActive'] as bool,
  participants:
      (json['participants'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      const [],
  aiAgents:
      (json['aiAgents'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList() ??
      const [],
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
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
  'userId': instance.userId,
  'isActive': instance.isActive,
  'participants': instance.participants,
  'aiAgents': instance.aiAgents,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'messages': instance.messages,
};

ChatRequest _$ChatRequestFromJson(Map<String, dynamic> json) => ChatRequest(
  message: json['message'] as String,
  conversationId: (json['conversationId'] as num?)?.toInt(),
  stream: json['stream'] as bool? ?? true,
);

Map<String, dynamic> _$ChatRequestToJson(ChatRequest instance) =>
    <String, dynamic>{
      'message': instance.message,
      'conversationId': instance.conversationId,
      'stream': instance.stream,
    };
