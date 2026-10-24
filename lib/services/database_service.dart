import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/exercise.dart';
import '../models/user_profile.dart';
import '../models/workout_session.dart';

class DatabaseService {
  static const String _usersKey = 'pnp_fitness_users_db';
  static const String _currentUserKey = 'pnp_fitness_current_user';
  static const String _exercisesKey = 'pnp_db_exercises_v2';
  static const String _darkModeKey = 'pnp_db_dark_mode_v2';

  static String _sessionKeyForUser(String username) =>
      'pnp_db_session_${username.toLowerCase()}';
  static String _historyKeyForUser(String username) =>
      'pnp_db_history_${username.toLowerCase()}';

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
  static Future<UserProfile?> loginUser(
    String username,
    String password,
  ) async {
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

  static List<Exercise> getDefaultExercises() {
    return [
      Exercise(
        id: 'EX01',
        name: 'Goblet Squat',
        description: 'Tập trung phát triển cơ đùi trước và cơ mông',
        durationInMinutes: 15,
        caloriesPerMinute: 9.5,
        category: 'Chân',
        setsAndReps: '4 hiệp x 12 lần',
        rating: 5,
      ),
      Exercise(
        id: 'EX02',
        name: 'Hít đất nâng cao',
        description: 'Phát triển cơ ngực, vai trước và tay sau',
        durationInMinutes: 12,
        caloriesPerMinute: 8.5,
        category: 'Ngực',
        setsAndReps: '3 hiệp x 15 lần',
        rating: 5,
      ),
      Exercise(
        id: 'EX03',
        name: 'Kéo tạ đơn một tay',
        description: 'Siết cơ lưng xô và cải thiện tư thế cột sống',
        durationInMinutes: 15,
        caloriesPerMinute: 8.0,
        category: 'Lưng',
        setsAndReps: '3 hiệp x 12 lần',
        rating: 4,
      ),
      Exercise(
        id: 'EX04',
        name: 'Plank siết cơ bụng',
        description: 'Tăng sức bền cơ lõi (Core) và giảm mỡ bụng',
        durationInMinutes: 10,
        caloriesPerMinute: 6.5,
        category: 'Bụng',
        setsAndReps: '3 hiệp x 60 giây',
        rating: 5,
      ),
      Exercise(
        id: 'EX05',
        name: 'Chạy bộ HIIT đốt mỡ',
        description: 'Tăng nhịp tim và đốt cháy năng lượng toàn thân',
        durationInMinutes: 25,
        caloriesPerMinute: 11.0,
        category: 'Cardio',
        setsAndReps: '25 phút liên tục',
        rating: 5,
      ),
    ];
  }

  static Future<List<Exercise>> loadExercises() async {
    final prefs = await SharedPreferences.getInstance();
    final rawJson = prefs.getString(_exercisesKey);

    if (rawJson == null || rawJson.isEmpty) {
      final defaults = getDefaultExercises();
      await saveExercises(defaults);
      return defaults;
    }

    final List<dynamic> decoded = jsonDecode(rawJson);
    return decoded
        .map((item) => Exercise.fromMap(Map<String, dynamic>.from(item)))
        .toList();
  }

  static Future<void> saveExercises(List<Exercise> exercises) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(
      exercises.map((exercise) => exercise.toMap()).toList(),
    );
    await prefs.setString(_exercisesKey, encoded);
  }

  static Future<WorkoutSession> loadWorkoutSession(
    String username,
    List<Exercise> catalog,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final rawJson = prefs.getString(_sessionKeyForUser(username));

    if (rawJson == null || rawJson.isEmpty) {
      final initialExercises = catalog
          .take(4)
          .map((exercise) => exercise.copyWith())
          .toList();
      final defaultSession = WorkoutSession(
        id: 'SS001',
        name: 'Buổi tập Toàn thân (Full Body)',
        description: 'Lộ trình đốt mỡ và tăng sức bền trong ngày',
        exercises: initialExercises,
      );
      await saveWorkoutSession(username, defaultSession);
      return defaultSession;
    }

    final Map<String, dynamic> decoded = jsonDecode(rawJson);
    return WorkoutSession.fromMap(decoded);
  }

  static Future<void> saveWorkoutSession(
    String username,
    WorkoutSession session,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(session.toMap());
    await prefs.setString(_sessionKeyForUser(username), encoded);
  }

  static Future<List<String>> loadWorkoutHistory(String username) async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_historyKeyForUser(username));
    if (saved == null) {
      final initialHistory = [
        'Hôm qua • Full Body (420 kcal - Hoàn thành 4/4 bài)',
      ];
      await saveWorkoutHistory(username, initialHistory);
      return initialHistory;
    }
    return saved;
  }

  static Future<void> saveWorkoutHistory(
    String username,
    List<String> history,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_historyKeyForUser(username), history);
  }

  static Future<bool> loadDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_darkModeKey) ?? false;
  }

  static Future<void> saveDarkMode(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkModeKey, isDark);
  }
}
