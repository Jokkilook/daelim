import 'dart:async';

import 'package:daelim/extensions/context_extension.dart';
import 'package:daelim/helpers/storage_helper.dart';
import 'package:easy_extension/easy_extension.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatScreen extends StatefulWidget {
  final String roomId;
  const ChatScreen({super.key, required this.roomId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String get _roomId => widget.roomId;

  final _client = Supabase.instance.client;
  StreamSubscription<List<Map<String, dynamic>>>? _messageStream;
  final _textController = TextEditingController();

  final _primaryColor = const Color(0xFF4E80EE);
  final _secondaryColor = Colors.white;
  final _backgroundColor = const Color(0xFFF3F4F6);

  final _dummyChatList = List<Map<String, dynamic>>.generate(6, (index) {
    return {
      'sender_id': index % 2 == 0 ? 'b' : 'a',
      'message': '현재 메시지 테스트 중입니다.',
      'created_at': DateTime.now().add(-index.toMinute),
    };
  });

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _startMessageStream();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _stopMessageStream();
    _textController.dispose();
    super.dispose();
  }

  //메시지 스트림
  void _startMessageStream() {
    _messageStream = _client
        .from("chat_messages")
        .stream(primaryKey: ["id"])
        .eq("room_id", _roomId)
        .listen((data) {
          Log.green(data);
        }, onError: (e, stack) {
          Log.red("스트림 에러: $e");
        });
  }

  void _stopMessageStream() {
    _messageStream?.cancel();
    _messageStream = null;
  }

  Future _onSendMessage() async {
    final message = _textController.text;
    final senderId = StorageHelper.authData!.userId;

    if (message.isNullOrEmpty || message.trim().isNullOrEmpty) return;

    final (sucess, error) = await _client
        .from("chat_messages")
        .insert({
          'room_id': _roomId,
          "sender_id": senderId,
          "message": message,
        })
        .then((value) => (true, ""))
        .catchError((e, stack) {
          Log.red(e);
          return (false, e.toString());
        });

    if (!sucess) {
      return context.showSnackBar(message: error);
    }

    _textController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: const Text('챗봇'),
      ),
      body: Column(
        children: [
          Expanded(
              child: StreamBuilder(
            stream: _client
                .from("chat_messages")
                .stream(primaryKey: ['id'])
                .eq("room_id", _roomId)
                .limit(10),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }

              final messageList = snapshot.data ?? [];
              Log.cyan(messageList);

              if (messageList.isEmpty) {
                return const Center(
                  child: Text("메세지를 전송하세요."),
                );
              }

              return ListView.separated(
                itemCount: messageList.length,
                separatorBuilder: (context, index) {
                  return 15.heightBox;
                },
                // padding: const EdgeInsets.only(right: 16, left: 16, top: 16),
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  final dummy = messageList[index];
                  final String senderId = dummy['sender_id'];
                  final String message = dummy['message'];
                  final DateTime createdAt = dummy['created_at'];

                  final isMy = senderId == 'a';

                  return Row(
                    mainAxisAlignment: isMy //
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: [
                      Container(
                        constraints: const BoxConstraints(
                          maxWidth: 250,
                          minWidth: 50,
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: const Radius.circular(5),
                              bottomRight: const Radius.circular(5),
                              topLeft: Radius.circular(isMy ? 5 : 0),
                              topRight: Radius.circular(isMy ? 0 : 5),
                            ),
                            color: isMy //
                                ? _primaryColor
                                : _secondaryColor,
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                offset: Offset(0, 1),
                                blurRadius: 2,
                                spreadRadius: 2,
                              )
                            ]),
                        child: ListTile(
                          title: Text(
                            message,
                            style: TextStyle(
                              color: isMy ? _secondaryColor : Colors.black,
                            ),
                          ),
                          subtitle: Text(
                            createdAt.toFormat('HH:mm'),
                            style: TextStyle(
                              color: isMy ? _secondaryColor : Colors.black54,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          )),
          // NOTE: 메시지 전송 영역
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _secondaryColor,
              border: Border(
                top: BorderSide(
                  color: Colors.grey[300]!,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      filled: false,
                      hintText: '메시지를 입력하세요...',
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                ),
                10.widthBox,
                ElevatedButton(
                  onPressed: _onSendMessage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 0,
                    ),
                  ),
                  child: const Text(
                    '전송',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
