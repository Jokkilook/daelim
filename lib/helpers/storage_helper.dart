import 'package:daelim/models/auth_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageHelper {
  static SharedPreferences? _prefs;
  static const String _authKey = "authKey";

  //초기화. [ 여기나 메인에서 WidgetsFlutterBinding.ensureInitialized(); 해줘야 함. ]
  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  //AuthData 저장하기
  static Future setAuthData(AuthData authData) async {
    await _prefs!.setString(_authKey, authData.toJson());
  }

  //AuthData 불러오기
  static AuthData? get authData {
    final data = _prefs!.getString(_authKey);
    return data != null ? AuthData.fromJson(data) : null;
  }

  //AuthData 삭제하기
  static Future removeAuthData() {
    return _prefs!.remove(_authKey);
  }
}
