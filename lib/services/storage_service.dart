import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String sessionIdKey = 'sessionId';

  // Lưu Session-Id
  Future<void> saveSessionId(String sessionId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(sessionIdKey, sessionId);
  }

  // Lấy Session-Id
  Future<String?> getSessionId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(sessionIdKey);
  }

  // Xóa Session-Id (dùng khi đăng xuất)
  Future<void> clearSessionId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(sessionIdKey);
  }
}