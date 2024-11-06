// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AuthData {
  final String email;
  final String tokenType;
  final String token;
  final DateTime expiresAt;
  AuthData({
    required this.email,
    required this.tokenType,
    required this.token,
    required this.expiresAt,
  });

  AuthData copyWith({
    String? email,
    String? tokenType,
    String? token,
    DateTime? expiresAt,
  }) {
    return AuthData(
      email: email ?? this.email,
      tokenType: tokenType ?? this.tokenType,
      token: token ?? this.token,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'token_type': tokenType,
      'access_token': token,
      'expires_at': expiresAt.millisecondsSinceEpoch ~/ 1000,
    };
  }

  factory AuthData.fromMap(Map<String, dynamic> map) {
    return AuthData(
      email: map['email'] as String,
      tokenType: map['token_type'] as String,
      token: map['access_token'] as String,
      expiresAt: DateTime.fromMillisecondsSinceEpoch(
          (map['expires_at'] as int) * 1000),
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthData.fromJson(String source) =>
      AuthData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'AuthData(eamil: $email, tokenType: $tokenType, token: $token, expiresAt: $expiresAt)';
}
