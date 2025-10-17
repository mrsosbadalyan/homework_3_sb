import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/grade_state.dart';

class PrefsService {
  static const _key = 'grade_state_v1';

  static Future<GradeState> load() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_key);
    if (jsonStr == null) return GradeState.defaults();
    try {
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      return GradeState.fromMap(map);
    } catch (_) {
      return GradeState.defaults();
    }
  }

  static Future<void> save(GradeState state) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = jsonEncode(state.toMap());
    await prefs.setString(_key, jsonStr);
  }

  static Future<void> resetAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
