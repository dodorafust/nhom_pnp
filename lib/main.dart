// File: lib/main.dart
import 'package:flutter/material.dart';
import 'package:device_frame/device_frame.dart';

import 'models/exercise.dart';
import 'models/user_profile.dart';
import 'models/workout_session.dart';
import 'screens/auth_screen.dart';
import 'screens/exercise_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/workout_screen.dart';
import 'services/database_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // 2. Chạy MockupApp (chứa khung điện thoại) thay vì chạy thẳng FitnessApp
  runApp(const MockupApp());
}

class MockupApp extends StatelessWidget {
  const MockupApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: Center(
          // 1. Sử dụng Padding để tạo khoảng cách an toàn so với viền màn hình
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 24.0,
              horizontal: 16.0,
            ),
            // 2. FittedBox giúp khung điện thoại tự động thu nhỏ lại để vừa khít màn hình máy tính
            child: FittedBox(
              fit: BoxFit.contain, // Không cho phép cắt xén (clip), bắt buộc thu nhỏ để thấy toàn bộ
              child: SizedBox(
                // 3. Ép cứng kích thước chuẩn của 1 chiếc iPhone 13 Pro Max (hoặc tỷ lệ chuẩn điện thoại)
                width: 428.0,
                height: 926.0,
                child: DeviceFrame(
                  device: Devices.ios.iPhone13ProMax, // Khung viền iPhone
                  isFrameVisible: true,
                  orientation: Orientation.portrait,
                  screen:
                      const FitnessApp(), // Nhét ứng dụng thật của bạn vào đây
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FitnessApp extends StatefulWidget {
  const FitnessApp({super.key});

  @override
  State<FitnessApp> createState() => _FitnessAppState();
}

class _FitnessAppState extends State<FitnessApp> {
  bool _isDarkMode = false;
  UserProfile? _currentUser;
  bool _isCheckingSession = true;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final savedUser = await DatabaseService.getCurrentLoggedInUser();
    final savedDark = await DatabaseService.loadDarkMode();
    if (!mounted) return;
    setState(() {
      _currentUser = savedUser;
      _isDarkMode = savedDark;
      _isCheckingSession = false;
    });
  }

  Future<void> _toggleTheme() async {
    setState(() => _isDarkMode = !_isDarkMode);
    await DatabaseService.saveDarkMode(_isDarkMode);
  }

  Future<void> _handleLogout() async {
    await DatabaseService.logout();
    if (!mounted) return;
    setState(() {
      _currentUser = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quản lý Tập luyện - Nhóm PNP',
      debugShowCheckedModeBanner: false,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: _isCheckingSession
          ? const Scaffold(
              body: Center(
                child: CircularProgressIndicator(color: Colors.teal),
              ),
            )
          : _currentUser != null
          ? MainNavigator(
              key: ValueKey(_currentUser!.username),
              currentUser: _currentUser!,
              isDarkMode: _isDarkMode,
              onToggleTheme: _toggleTheme,
              onLogout: _handleLogout,
            )
          : LoginScreen(
              onLoginSuccess: (loggedInUser) {
                setState(() => _currentUser = loggedInUser);
              },
            ),
    );
  }
}

class MainNavigator extends StatefulWidget {
  final UserProfile currentUser;
  final bool isDarkMode;
  final VoidCallback onToggleTheme;
  final VoidCallback onLogout;

  const MainNavigator({
    super.key,
    required this.currentUser,
    required this.isDarkMode,
    required this.onToggleTheme,
    required this.onLogout,
  });

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  int _selectedIndex = 0;
  bool _isLoadingData = true;

  List<Exercise> _allExercises = [];
  late WorkoutSession _currentSession;
  List<String> _workoutHistory = [];

  @override
  void initState() {
    super.initState();
    _loadPersistentData();
  }

  Future<void> _loadPersistentData() async {
    final exercises = await DatabaseService.loadExercises();
    final session = await DatabaseService.loadWorkoutSession(
      widget.currentUser.username,
      exercises,
    );
    final history = await DatabaseService.loadWorkoutHistory(
      widget.currentUser.username,
    );

    if (!mounted) return;
    setState(() {
      _allExercises = exercises;
      _currentSession = session;
      _workoutHistory = history;
      _isLoadingData = false;
    });
  }

  Future<void> _persistExercises() async {
    await DatabaseService.saveExercises(_allExercises);
  }

  Future<void> _persistSession() async {
    await DatabaseService.saveWorkoutSession(
      widget.currentUser.username,
      _currentSession,
    );
  }

  Future<void> _persistHistory() async {
    await DatabaseService.saveWorkoutHistory(
      widget.currentUser.username,
      _workoutHistory,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingData) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.teal)),
      );
    }

    final screens = <Widget>[
      ExerciseScreen(
        exercises: _allExercises,
        onAddExercise: (newEx) {
          setState(() => _allExercises.add(newEx));
          _persistExercises();
        },
        onUpdateExercise: (updatedEx) {
          setState(() {
            final idx = _allExercises.indexWhere((e) => e.id == updatedEx.id);
            if (idx != -1) _allExercises[idx] = updatedEx;
          });
          _persistExercises();
        },
        onDeleteExercise: (exId) {
          setState(() {
            _allExercises.removeWhere((e) => e.id == exId);
            _currentSession.exercises.removeWhere((e) => e.id == exId);
          });
          _persistExercises();
          _persistSession();
        },
        onSendToWorkout: (ex) {
          setState(() {
            final exists = _currentSession.exercises.any(
              (item) => item.id == ex.id,
            );
            if (!exists) {
              _currentSession.addExercise(ex.copyWith(isCompleted: false));
            }
          });
          _persistSession();
        },
        onApplyChallengePlan: (planName, selectedList) {
          setState(() {
            _currentSession = WorkoutSession(
              id: _currentSession.id,
              name: planName,
              description:
                  'Áp dụng từ Thử thách 30 ngày (${selectedList.length} bài tập)',
              elapsedSeconds: 0,
              exercises: selectedList
                  .map((e) => e.copyWith(isCompleted: false))
                  .toList(),
            );
            _selectedIndex = 1; // Chuyển ngay sang Tab Buổi tập
          });
          _persistSession();
        },
        onResetDefaultExercises: () {
          setState(() {
            _allExercises = DatabaseService.getDefaultExercises();
          });
          _persistExercises();
        },
      ),
      WorkoutScreen(
        currentSession: _currentSession,
        allCatalogExercises: _allExercises,
        workoutHistory: _workoutHistory,
        onSessionChanged: () {
          setState(() {});
          _persistSession();
        },
        onEditSessionInfo: (newName, newDesc) {
          setState(() {
            _currentSession = WorkoutSession(
              id: _currentSession.id,
              name: newName,
              description: newDesc,
              date: _currentSession.date,
              elapsedSeconds: _currentSession.elapsedSeconds,
              exercises: _currentSession.exercises,
            );
          });
          _persistSession();
        },
        onResetSessionProgress: () {
          setState(() {
            for (final ex in _currentSession.exercises) {
              ex.isCompleted = false;
            }
            _currentSession.elapsedSeconds = 0;
          });
          _persistSession();
        },
        onAddHistoryLog: (log) {
          setState(() => _workoutHistory.insert(0, log));
          _persistHistory();
        },
        onDeleteHistoryLog: (idx) {
          setState(() => _workoutHistory.removeAt(idx));
          _persistHistory();
        },
      ),
      ProfileScreen(
        userProfile: widget.currentUser,
        isDarkMode: widget.isDarkMode,
        onToggleTheme: widget.onToggleTheme,
        onProfileUpdated: () => setState(() {}),
        onLogout: widget.onLogout,
      ),
    ];

    return Scaffold(
      // Dùng IndexedStack để giữ nguyên trạng thái và bộ đếm giờ khi chuyển qua lại giữa 3 tab
      body: IndexedStack(index: _selectedIndex, children: screens),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Bài tập'),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Buổi tập',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Hồ sơ'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal,
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}
