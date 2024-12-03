class Config {
  static const String _baseFunctionUrl =
      "https://daelim-server.fleecy.dev/functions/v1";
  static const String _storagePublicUrl =
      "https://daelim-server.fleecy.dev/storage/v1/object/public";

  static const icon = (
    icGoogle: "$_storagePublicUrl/icons/google.png",
    icGithub: "$_storagePublicUrl/icons/github.png",
    icApple: "$_storagePublicUrl/icons/apple.png"
  );

  static const image = (defaultProfile: "$_storagePublicUrl/icons/user.png");

  static const api = (
    getToken: "$_baseFunctionUrl/auth/get-token",
    getUserData: "$_baseFunctionUrl/auth/my-data",
    setProfileImage: "$_baseFunctionUrl/auth/set-profile-image",
    getUserList: "$_baseFunctionUrl/users",
    changePassword: "$_baseFunctionUrl/auth/reset-password",
    createRoom: "$_baseFunctionUrl/chat/room/create"
  );

  static const storage = ();

  static const supabseUrl = "https://daelim-server.fleecy.dev";

  static const anonKey =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.ewogICJyb2xlIjogImFub24iLAogICJpc3MiOiAic3VwYWJhc2UiLAogICJpYXQiOiAxNzE3MzQwNDAwLAogICJleHAiOiAxODc1MTA2ODAwCn0.aMXxldFuuDXaZhl1Ap5bTQS_601EwbOOVE8YdPmAuc8";
}
