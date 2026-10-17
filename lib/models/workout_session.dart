import 'base_entity.dart';
import 'exercise.dart';

class WorkoutSession extends BaseEntity<int> {
  final String date;
  final List<Exercise> exercises;

  const WorkoutSession({
    required super.id,
    required super.name,
    required super.description,
    required this.date,
    required this.exercises,
  });

  double getTotalSessionCalories() {
    double total = 0;
    for (var ex in exercises) {
      total += ex.getBurnedCalories();
    }
    return total;
  }

  @override
  String getDetailInfo() {
    return 'Ngày: $date | Số bài tập: ${exercises.length} | Tổng: ${getTotalSessionCalories().toStringAsFixed(1)} kcal';
  }
}