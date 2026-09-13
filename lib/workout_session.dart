import 'exercise.dart';

class WorkoutSession {
  String sessionId;
  DateTime date;
  List exercises = [];

  WorkoutSession({required this.sessionId, required this.date});

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
}