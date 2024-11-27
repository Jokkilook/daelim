// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MessageData {
  final String room_id;
  final String joined_at;
  MessageData({
    required this.room_id,
    required this.joined_at,
  });

  MessageData copyWith({
    String? room_id,
    String? joined_at,
  }) {
    return MessageData(
      room_id: room_id ?? this.room_id,
      joined_at: joined_at ?? this.joined_at,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'room_id': room_id,
      'joined_at': joined_at,
    };
  }

  factory MessageData.fromMap(Map<String, dynamic> map) {
    return MessageData(
      room_id: map['room_id'] as String,
      joined_at: map['joined_at'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageData.fromJson(String source) =>
      MessageData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'MessageData(room_id: $room_id, joined_at: $joined_at)';

  @override
  bool operator ==(covariant MessageData other) {
    if (identical(this, other)) return true;

    return other.room_id == room_id && other.joined_at == joined_at;
  }

  @override
  int get hashCode => room_id.hashCode ^ joined_at.hashCode;
}
