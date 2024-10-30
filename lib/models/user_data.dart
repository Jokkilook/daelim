// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserData {
  final String id;
  final String name;
  final String student_number;
  final String email;
  final String? profile_image;
  final DateTime? last_sign_in_at;
  UserData({
    required this.id,
    required this.name,
    required this.student_number,
    required this.email,
    this.profile_image,
    this.last_sign_in_at,
  });

  UserData copyWith({
    String? id,
    String? name,
    String? student_Numder,
    String? email,
    String? profile_image,
    DateTime? last_sign_in_at,
  }) {
    return UserData(
      id: id ?? this.id,
      name: name ?? this.name,
      student_number: student_Numder ?? student_number,
      email: email ?? this.email,
      profile_image: profile_image ?? this.profile_image,
      last_sign_in_at: last_sign_in_at ?? this.last_sign_in_at,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'student_number': student_number,
      'email': email,
      'profile_image': profile_image,
      'last_sign_in_at': last_sign_in_at,
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      id: map['id'] as String,
      name: map['name'] as String,
      student_number: map['student_number'] as String,
      email: map['email'] as String,
      profile_image:
          map['profile_image'] != null ? map['profile_image'] as String : null,
      last_sign_in_at: map['last_sign_in_at'] != null
          ? DateTime.parse(map['last_sign_in_at']).toLocal()
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserData.fromJson(String source) =>
      UserData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserData(id: $id, name: $name, student_number: $student_number, email: $email, profile_image: $profile_image, last_sign_in_at: $last_sign_in_at)';
  }

  @override
  bool operator ==(covariant UserData other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.student_number == student_number &&
        other.email == email &&
        other.profile_image == profile_image &&
        other.last_sign_in_at == last_sign_in_at;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        student_number.hashCode ^
        email.hashCode ^
        profile_image.hashCode ^
        last_sign_in_at.hashCode;
  }
}
