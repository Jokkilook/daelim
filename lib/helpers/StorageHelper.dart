import 'package:daelim/models/auth_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageHelper {
  static late SharedPreferences prefs;
  static const String _authKey = "authKey";

  static Future init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static Future setAuthData(AuthData authData) async {
    await prefs.setString(_authKey, authData.toJson());
  }

  static AuthData? getAuthData() {
    final data = prefs.getString(_authKey);
    return data != null ? AuthData.fromJson(data) : null;
  }
}
