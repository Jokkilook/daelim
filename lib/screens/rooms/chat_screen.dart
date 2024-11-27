import 'package:easy_extension/easy_extension.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String roomId;
  const ChatScreen({super.key, required this.roomId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _primaryColor = const Color(0xFF4E80EE);
  final _secondaryColor = Colors.white;
  final _backgroundColor = const Color(0xFFF3F4F6);

  final _dummyChatList = [
    {
      "sender_id": "a",
      "message": "끼룩끼룩",
      "created_at": DateTime.now().add(-1.toHour)
    },
    {
      "sender_id": "b",
      "message": "까악까악",
      "created_at": DateTime.now().add(-1.toHour)
    },
    {
      "sender_id": "a",
      "message": "삐약삐약",
      "created_at": DateTime.now().add(-1.toHour)
    },
    {
      "sender_id": "b",
      "message": "구구구구",
      "created_at": DateTime.now().add(-1.toHour)
    },
    {
      "sender_id": "a",
      "message": "미야오",
      "created_at": DateTime.now().add(-1.toHour)
    },
    {
      "sender_id": "b",
      "message": "멍",
      "created_at": DateTime.now().add(-1.toHour)
    }
  ];

  void _onSendMessage() {}
  String get roomId => widget.roomId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: Text(roomId),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: _dummyChatList.length,
              shrinkWrap: true,
              separatorBuilder: (context, index) {
                return 10.heightBox;
              },
              itemBuilder: (context, index) {
                final dummy = _dummyChatList[index];
                final String senderId = dummy["sender_id"] as String;
                final String message = dummy["message"] as String;
                final DateTime createdAt = dummy["created_at"] as DateTime;

                final isMine = senderId == "a";

                return Row(
                  mainAxisAlignment:
                      isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    Container(
                      constraints: const BoxConstraints(
                        minHeight: 50,
                        maxHeight: 250,
                      ),
                      color: isMine ? _primaryColor : _secondaryColor,
                      child: ListTile(
                        title: Text(
                          message,
                          style: TextStyle(
                            color: isMine ? _secondaryColor : Colors.black,
                          ),
                        ),
                        subtitle: Text(
                          createdAt.toFormat("HH:mm"),
                          style: TextStyle(
                            color: senderId == "a"
                                ? _secondaryColor
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          //메시지 전송 부분
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _secondaryColor,
              border: Border(
                top: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                  minLines: 1,
                  maxLines: 1,
                  decoration: InputDecoration(
                    hintText: "메시지를 입력하세요.",
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    filled: false,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                )),
                10.widthBox,
                ElevatedButton(
                  onPressed: _onSendMessage,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryColor,
                      padding: const EdgeInsets.symmetric(horizontal: 0)),
                  child: Text(
                    "전송",
                    style: TextStyle(
                        color: _secondaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
