// File: lib/models/user_profile.dart
import 'base_entity.dart';

class UserProfile extends BaseEntity<String> {
  final String username;
  final String password;
  double weight; // kg
  double height; // mét
  int waterGlasses; // Số cốc nước đã uống

  UserProfile({
    required super.id,
    required this.username,
    required this.password,
    required super.name,
    super.description = 'Mục tiêu: Săn chắc cơ bắp & duy trì thể lực',
    required this.weight,
    required this.height,
    this.waterGlasses = 4,
  });

  double get bmiValue {
    if (height <= 0 || weight <= 0) return 0;
    return weight / (height * height);
  }

  // Thuật toán tính BMI và phân loại sức khỏe
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

  // Chuyển đổi đối tượng sang Map để lưu vào Database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'name': name,
      'description': description,
      'weight': weight,
      'height': height,
      'waterGlasses': waterGlasses,
    };
  }

  // Khôi phục đối tượng từ dữ liệu Database
  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'] ?? 'U001',
      username: map['username'] ?? '',
      password: map['password'] ?? '',
      name: map['name'] ?? 'Học viên',
      description: map['description'] ?? 'Thành viên PNP Fitness',
      weight: (map['weight'] as num?)?.toDouble() ?? 65.0,
      height: (map['height'] as num?)?.toDouble() ?? 1.70,
      waterGlasses: (map['waterGlasses'] as num?)?.toInt() ?? 0,
    );
  }
}