import 'exercise.dart';

class WorkoutSession {
  String sessionId;
  DateTime date;
  List<Exercise> exercises = [];

  WorkoutSession({required this.sessionId, required this.date});

  void addExercise(Exercise exercise) {
    exercises.add(exercise);
  }

  // Thuật toán lặp tính tổng calo cho cả buổi tập
  double calculateTotalCalories() {
    double total = 0.0;
    for (var exercise in exercises) {
      total += exercise.getBurnedCalories();
    }
    return total;
  }
}