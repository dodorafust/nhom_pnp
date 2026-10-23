// File: lib/models/exercise.dart
import 'base_entity.dart';

class Exercise extends BaseEntity<String> {
  final int durationInMinutes;
  final double caloriesPerMinute;
  final String category; // Nhóm cơ: Ngực, Lưng, Chân, Bụng, Cardio
  final String setsAndReps; // Ví dụ: 4 hiệp x 12 lần
  int rating; // Đánh giá từ 1 - 5 sao
  bool isCompleted;

  Exercise({
    required super.id,
    String? name,
    String? exerciseName,
    super.description = 'Bài tập thể lực tiêu chuẩn',
    required this.durationInMinutes,
    required this.caloriesPerMinute,
    this.category = 'Toàn thân',
    this.setsAndReps = '3 hiệp x 12 lần',
    this.rating = 5,
    this.isCompleted = false,
  }) : super(name: name ?? exerciseName ?? 'Bài tập');

  String get exerciseName => name;

  // Thuật toán tính lượng calo đốt cháy của bài tập
  double getBurnedCalories() {
    return durationInMinutes * caloriesPerMinute;
  }

  @override
  String getDetailInfo() {
    return '$category • $setsAndReps • ${durationInMinutes}p (${getBurnedCalories().toStringAsFixed(0)} kcal)';
  }
}