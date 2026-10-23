// File: lib/services/database_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';

class DatabaseService {
  static const String _usersKey = 'pnp_fitness_users_db';
  static const String _currentUserKey = 'pnp_fitness_current_user';

  // Khởi tạo Database với 3 tài khoản mặc định của nhóm nếu chạy lần đầu
  static Future<List<UserProfile>> getAllUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final String? usersJson = prefs.getString(_usersKey);

    if (usersJson == null || usersJson.isEmpty) {
      final defaultUsers = [
        UserProfile(
          id: '23017073',
          username: 'phat',
          password: '123456',
          name: 'Phan Văn Phát',
          description: 'Phụ trách: UserProfile & Hồ sơ BMI',
          weight: 68.0,
          height: 1.72,
          waterGlasses: 5,
        ),
        UserProfile(
          id: '23010247',
          username: 'phong',
          password: '123456',
          name: 'Nguyễn Hoàng Phong',
          description: 'Phụ trách: WorkoutSession & Buổi tập',
          weight: 70.0,
          height: 1.75,
          waterGlasses: 6,
        ),
        UserProfile(
          id: '23017272',
          username: 'nam',
          password: '123456',
          name: 'Hoàng Hải Nam',
          description: 'Phụ trách: Exercise & Thư viện Bài tập',
          weight: 65.0,
          height: 1.70,
          waterGlasses: 4,
        ),
      ];
      await _saveAllUsers(defaultUsers);
      return defaultUsers;
    }

    final List<dynamic> decoded = jsonDecode(usersJson);
    return decoded.map((item) => UserProfile.fromMap(item)).toList();
  }

  static Future<void> _saveAllUsers(List<UserProfile> users) async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(users.map((u) => u.toMap()).toList());
    await prefs.setString(_usersKey, encoded);
  }

  // 1. Đăng ký tài khoản mới vào Database
  static Future<bool> registerUser(UserProfile newUser) async {
    final users = await getAllUsers();
    final exists = users.any(
      (u) => u.username.toLowerCase() == newUser.username.toLowerCase(),
    );
    if (exists) {
      return false; // Trùng username
    }
    users.add(newUser);
    await _saveAllUsers(users);
    return true;
  }

  // 2. Kiểm tra thông tin Đăng nhập từ Database
  static Future<UserProfile?> loginUser(String username, String password) async {
    final users = await getAllUsers();
    for (final user in users) {
      if (user.username.toLowerCase() == username.trim().toLowerCase() &&
          user.password == password) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_currentUserKey, user.username);
        return user;
      }
    }
    return null;
  }

  // 3. Cập nhật thông tin người dùng (BMI, cân nặng, chiều cao, nước uống)
  static Future<void> updateUserProfile(UserProfile updatedUser) async {
    final users = await getAllUsers();
    final index = users.indexWhere(
      (u) => u.username.toLowerCase() == updatedUser.username.toLowerCase(),
    );
    if (index != -1) {
      users[index] = updatedUser;
      await _saveAllUsers(users);
    }
  }

  // 4. Lấy người dùng đang đăng nhập hiện tại
  static Future<UserProfile?> getCurrentLoggedInUser() async {
    final prefs = await SharedPreferences.getInstance();
    final String? currentUsername = prefs.getString(_currentUserKey);
    if (currentUsername == null) return null;

    final users = await getAllUsers();
    for (final user in users) {
      if (user.username.toLowerCase() == currentUsername.toLowerCase()) {
        return user;
      }
    }
    return null;
  }

  // 5. Đăng xuất tài khoản
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
  }
}