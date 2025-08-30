import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class User extends Equatable {
  final int id;
  final String email;
  final String? fullName;
  final bool isActive;
  final bool isVerified;
  final DateTime createdAt;
  final DateTime updatedAt;

  const User({
    required this.id,
    required this.email,
    this.fullName,
    required this.isActive,
    required this.isVerified,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  List<Object?> get props => [
        id,
        email,
        fullName,
        isActive,
        isVerified,
        createdAt,
        updatedAt,
      ];
}

@JsonSerializable(fieldRename: FieldRename.snake)
class UserCreate extends Equatable {
  final String email;
  final String? fullName;
  final String password;

  const UserCreate({
    required this.email,
    this.fullName,
    required this.password,
  });

  factory UserCreate.fromJson(Map<String, dynamic> json) =>
      _$UserCreateFromJson(json);

  Map<String, dynamic> toJson() => _$UserCreateToJson(this);

  @override
  List<Object?> get props => [email, fullName, password];
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Token extends Equatable {
  final String accessToken;
  final String tokenType;

  const Token({
    required this.accessToken,
    this.tokenType = 'bearer',
  });

  factory Token.fromJson(Map<String, dynamic> json) => _$TokenFromJson(json);

  Map<String, dynamic> toJson() => _$TokenToJson(this);

  @override
  List<Object?> get props => [accessToken, tokenType];
}
