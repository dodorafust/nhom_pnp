// File: lib/models/workout_session.dart
import 'base_entity.dart';
import 'exercise.dart';

class WorkoutSession extends BaseEntity<String> {
  final DateTime date;
  final List<Exercise> exercises;
  int elapsedSeconds;

  WorkoutSession({
    String? id,
    String? sessionId,
    super.name = 'Buổi tập Toàn thân (Full Body)',
    super.description = 'Lộ trình đốt mỡ và tăng sức bền trong ngày',
    DateTime? date,
    List<Exercise>? exercises,
    this.elapsedSeconds = 0,
  })  : date = date ?? DateTime.now(),
        exercises = exercises ?? [],
        super(id: id ?? sessionId ?? 'SS001');

  String get sessionId => id;

  void addExercise(Exercise exercise) {
    exercises.add(exercise);
  }

  double calculateTotalCalories() {
    double total = 0.0;
    for (var exercise in exercises) {
      total += exercise.getBurnedCalories();
    }
    return total;
  }

  double calculateCompletedCalories() {
    double total = 0.0;
    for (var exercise in exercises) {
      if (exercise.isCompleted) {
        total += exercise.getBurnedCalories();
      }
    }
    return total;
  }

  int get completedCount => exercises.where((e) => e.isCompleted).length;

  @override
  String getDetailInfo() {
    final dateStr =
        '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    return 'Ngày: $dateStr • ${exercises.length} bài tập • Tổng: ${calculateTotalCalories().toStringAsFixed(0)} kcal';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'date': date.toIso8601String(),
      'elapsedSeconds': elapsedSeconds,
      'exercises': exercises.map((e) => e.toMap()).toList(),
    };
  }

  factory WorkoutSession.fromMap(Map<String, dynamic> map) {
    final rawList = (map['exercises'] as List<dynamic>?) ?? [];
    return WorkoutSession(
      id: map['id']?.toString() ?? 'SS001',
      name: map['name']?.toString() ?? 'Buổi tập hôm nay',
      description:
          map['description']?.toString() ?? 'Lộ trình tập luyện cá nhân',
      date: DateTime.tryParse(map['date']?.toString() ?? '') ?? DateTime.now(),
      elapsedSeconds: (map['elapsedSeconds'] as num?)?.toInt() ?? 0,
      exercises: rawList
          .map((item) => Exercise.fromMap(Map<String, dynamic>.from(item)))
          .toList(),
    );
  }
}