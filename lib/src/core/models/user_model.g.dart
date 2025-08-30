// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: (json['id'] as num).toInt(),
  email: json['email'] as String,
  fullName: json['fullName'] as String?,
  isActive: json['isActive'] as bool,
  isVerified: json['isVerified'] as bool,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'fullName': instance.fullName,
  'isActive': instance.isActive,
  'isVerified': instance.isVerified,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};

UserCreate _$UserCreateFromJson(Map<String, dynamic> json) => UserCreate(
  email: json['email'] as String,
  fullName: json['fullName'] as String?,
  password: json['password'] as String,
);

Map<String, dynamic> _$UserCreateToJson(UserCreate instance) =>
    <String, dynamic>{
      'email': instance.email,
      'fullName': instance.fullName,
      'password': instance.password,
    };

Token _$TokenFromJson(Map<String, dynamic> json) => Token(
  accessToken: json['accessToken'] as String,
  tokenType: json['tokenType'] as String? ?? 'bearer',
);

Map<String, dynamic> _$TokenToJson(Token instance) => <String, dynamic>{
  'accessToken': instance.accessToken,
  'tokenType': instance.tokenType,
};
