// File: lib/main.dart
import 'package:flutter/material.dart';
import 'models/exercise.dart';
import 'models/user_profile.dart';
import 'models/workout_session.dart';
import 'screens/auth_screen.dart';
import 'screens/exercise_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/workout_screen.dart';

void main() => runApp(const FitnessApp());

class FitnessApp extends StatefulWidget {
  const FitnessApp({super.key});

  @override
  State<FitnessApp> createState() => _FitnessAppState();
}

class _FitnessAppState extends State<FitnessApp> {
  bool _isDarkMode = false;
  bool _isAuthenticated = false;

  void _toggleTheme() {
    setState(() => _isDarkMode = !_isDarkMode);
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
      home: _isAuthenticated
          ? MainNavigator(
              isDarkMode: _isDarkMode,
              onToggleTheme: _toggleTheme,
            )
          : AuthScreen(
              onLoginSuccess: () => setState(() => _isAuthenticated = true),
            ),
    );
  }
}

class MainNavigator extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const MainNavigator({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  int _selectedIndex = 0;

  // Dữ liệu bài tập khởi tạo ban đầu
  final List<Exercise> _allExercises = [
    Exercise(
      id: 'EX01',
      name: 'Goblet Squat',
      description: 'Tập trung phát triển cơ đùi trước và cơ mông',
      durationInMinutes: 15,
      caloriesPerMinute: 9.5,
      category: 'Chân',
      setsAndReps: '4 hiệp x 12 lần',
    ),
    Exercise(
      id: 'EX02',
      name: 'Hít đất nâng cao',
      description: 'Phát triển cơ ngực, vai trước và tay sau',
      durationInMinutes: 12,
      caloriesPerMinute: 8.5,
      category: 'Ngực',
      setsAndReps: '3 hiệp x 15 lần',
    ),
    Exercise(
      id: 'EX03',
      name: 'Kéo tạ đơn một tay',
      description: 'Siết cơ lưng xô và cải thiện tư thế cột sống',
      durationInMinutes: 15,
      caloriesPerMinute: 8.0,
      category: 'Lưng',
      setsAndReps: '3 hiệp x 12 lần',
    ),
    Exercise(
      id: 'EX04',
      name: 'Plank siết cơ bụng',
      description: 'Tăng sức bền cơ lõi (Core) và giảm mỡ bụng',
      durationInMinutes: 10,
      caloriesPerMinute: 6.5,
      category: 'Bụng',
      setsAndReps: '3 hiệp x 60 giây',
    ),
    Exercise(
      id: 'EX05',
      name: 'Chạy bộ HIIT đốt mỡ',
      description: 'Tăng nhịp tim và đốt cháy năng lượng toàn thân',
      durationInMinutes: 25,
      caloriesPerMinute: 11.0,
      category: 'Cardio',
      setsAndReps: '25 phút liên tục',
    ),
  ];

  late final WorkoutSession _currentSession;
  final UserProfile _userProfile = UserProfile(
    id: '23017073',
    name: 'Phan Văn Phát',
    description: 'Mục tiêu: Duy trì thể lực & săn chắc cơ bắp',
    weight: 68.0,
    height: 1.72,
  );

  @override
  void initState() {
    super.initState();
    _currentSession = WorkoutSession(
      id: 'SS001',
      name: 'Buổi tập Toàn thân (Full Body)',
      description: 'Lộ trình đốt mỡ và tăng sức bền trong ngày',
      exercises: [
        _allExercises[0],
        _allExercises[1],
        _allExercises[3],
        _allExercises[4],
      ],
    );
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final screens = <Widget>[
      ExerciseScreen(
        exercises: _allExercises,
        onAddExercise: (newEx) {
          setState(() => _allExercises.add(newEx));
        },
        onSendToWorkout: (ex) {
          setState(() {
            if (!_currentSession.exercises.contains(ex)) {
              _currentSession.addExercise(ex);
            }
          });
        },
      ),
      WorkoutScreen(
        currentSession: _currentSession,
        onSessionUpdated: () => setState(() {}),
      ),
      ProfileScreen(
        userProfile: _userProfile,
        isDarkMode: widget.isDarkMode,
        onToggleTheme: widget.onToggleTheme,
        onProfileUpdated: () => setState(() {}),
      ),
    ];

    return Scaffold(
      body: screens.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Bài tập',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Buổi tập',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Hồ sơ',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal,
        onTap: _onItemTapped,
      ),
    );
  }
}