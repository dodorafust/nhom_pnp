// File: lib/models/user_profile.dart
import 'base_entity.dart';

class UserProfile extends BaseEntity<String> {
  double weight; // kg
  double height; // mét
  int waterGlasses; // Số cốc nước đã uống trong ngày
  int dailyCalorieGoal;

  UserProfile({
    super.id = '23017073',
    required super.name,
    super.description = 'Mục tiêu: Săn chắc cơ bắp & duy trì thể lực',
    required this.weight,
    required this.height,
    this.waterGlasses = 4,
    this.dailyCalorieGoal = 500,
  });

  double get bmiValue {
    if (height <= 0 || weight <= 0) return 0;
    return weight / (height * height);
  }

  // Thuật toán tính BMI và rẽ nhánh phân loại tình trạng cơ thể
  String calculateBMI() {
    if (height <= 0 || weight <= 0) return 'Dữ liệu không hợp lệ';

    final bmi = bmiValue;
    String status;

    if (bmi < 18.5) {
      status = 'Thiếu cân (Cần bổ sung dinh dưỡng)';
    } else if (bmi < 24.9) {
      status = 'Bình thường (Thể trạng lý tưởng)';
    } else if (bmi < 29.9) {
      status = 'Thừa cân (Nên tăng cường Cardio)';
    } else {
      status = 'Béo phì (Cần lộ trình giảm mỡ chuyên sâu)';
    }
    return 'BMI: ${bmi.toStringAsFixed(1)} - $status';
  }

  @override
  String getDetailInfo() {
    return 'Cân nặng: ${weight}kg | Chiều cao: ${height}m | ${calculateBMI()}';
  }
}