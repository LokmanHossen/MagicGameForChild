// ignore_for_file: constant_identifier_names

import 'package:get_storage/get_storage.dart';
import '../models/user_model.dart';

class StorageService {
  final _storage = GetStorage();

  static const String USER_KEY = 'user_data';
  static const String IS_FIRST_TIME = 'is_first_time';

  // Save user data
  Future<void> saveUser(UserModel user) async {
    await _storage.write(USER_KEY, user.toJson());
  }

  // Get user data
  UserModel? getUser() {
    final userData = _storage.read(USER_KEY);
    if (userData != null) {
      return UserModel.fromJson(userData);
    }
    return null;
  }

  // Check if user exists
  bool hasUser() {
    return _storage.hasData(USER_KEY);
  }

  // Clear user data
  Future<void> clearUser() async {
    await _storage.remove(USER_KEY);
  }

  // First time check
  bool isFirstTime() {
    return _storage.read(IS_FIRST_TIME) ?? true;
  }

  // Set first time completed
  Future<void> setFirstTimeCompleted() async {
    await _storage.write(IS_FIRST_TIME, false);
  }

  // Update user
  Future<void> updateUser(UserModel user) async {
    await saveUser(user);
  }
}
