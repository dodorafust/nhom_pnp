// File: lib/models/exercise.dart
import 'base_entity.dart';

class Exercise extends BaseEntity<String> {
  final int durationInMinutes;
  final double caloriesPerMinute;

  const Exercise({
    required super.id,
    required super.name,
    required super.description,
    required this.durationInMinutes,
    required this.caloriesPerMinute,
  });

  // Phương thức tính tổng calo tiêu thụ của bài tập
  double getBurnedCalories() {
    return durationInMinutes * caloriesPerMinute;
  }

  // Ghi đè phương thức chung từ BaseEntity
  @override
  String getDetailInfo() {
    return 'Thời lượng: $durationInMinutes phút | Tiêu hao: ${getBurnedCalories().toStringAsFixed(1)} kcal';
  }
}