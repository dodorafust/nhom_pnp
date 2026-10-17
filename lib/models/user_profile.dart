// File: lib/models/user_profile.dart
import 'base_entity.dart';

class UserProfile extends BaseEntity<String> {
  final double weight; // kg
  final double height; // mét

  const UserProfile({
    required super.id,
    required super.name,
    required super.description,
    required this.weight,
    required this.height,
  });

  double get bmiValue => weight / (height * height);

  String calculateBMI() {
    final bmi = bmiValue;
    if (bmi < 18.5) {
      return 'BMI: ${bmi.toStringAsFixed(1)} (Thiếu cân)';
    } else if (bmi < 24.9) {
      return 'BMI: ${bmi.toStringAsFixed(1)} (Bình thường)';
    } else if (bmi < 29.9) {
      return 'BMI: ${bmi.toStringAsFixed(1)} (Thừa cân)';
    } else {
      return 'BMI: ${bmi.toStringAsFixed(1)} (Béo phì)';
    }
  }

  @override
  String getDetailInfo() {
    return 'Cân nặng: ${weight}kg | Chiều cao: ${height}m | ${calculateBMI()}';
  }
}