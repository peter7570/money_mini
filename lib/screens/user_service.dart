// lib/services/user_service.dart

import 'package:hive_flutter/hive_flutter.dart';

class UserService {
  final Box _box = Hive.box('users');

  Future<String?> register(String email, String password) async {
    if (_box.containsKey(email)) {
      return 'Цей email вже зареєстрований';
    }
    await _box.put(email, password);
    return null; // успех
  }

  bool login(String email, String password) {
    if (!_box.containsKey(email)) return false;
    return _box.get(email) == password;
  }

  bool isRegistered(String email) => _box.containsKey(email);
}
