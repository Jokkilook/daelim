class ApiError {
  //쓰려다가 switch에서 const 변수 사용 안돼서 버림.
  final createRoomSuccess = 200;
  static const createChatRomm = (
    success: 200,
    requiredUserId: 1001,
    cannotMySelf: 1002,
    notFound: 1003,
    onlyCnChatbot: 1004,
    alreadyRoom: 1005,
  );
}
