// File: lib/models/workout_session.dart
import 'base_entity.dart';
import 'exercise.dart';

class WorkoutSession extends BaseEntity<String> {
  final DateTime date;
  final List<Exercise> exercises;

  WorkoutSession({
    String? id,
    String? sessionId,
    super.name = 'Buổi tập Full Body đốt mỡ',
    super.description = 'Kết hợp Cardio và kháng lực cường độ cao',
    DateTime? date,
    List<Exercise>? exercises,
  })  : date = date ?? DateTime.now(),
        exercises = exercises ?? [],
        super(id: id ?? sessionId ?? 'SS01');

  String get sessionId => id;

  void addExercise(Exercise exercise) {
    exercises.add(exercise);
  }

  // Thuật toán lặp tính tổng calo cho toàn bộ buổi tập
  double calculateTotalCalories() {
    double total = 0.0;
    for (var exercise in exercises) {
      total += exercise.getBurnedCalories();
    }
    return total;
  }

  // Tính lượng calo của các bài đã đánh dấu hoàn thành
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
    return 'Ngày: $dateStr | ${exercises.length} bài tập | Mục tiêu: ${calculateTotalCalories().toStringAsFixed(0)} kcal';
  }
}