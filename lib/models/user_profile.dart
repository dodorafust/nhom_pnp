// File: lib/models/user_profile.dart
import 'base_entity.dart';

class UserProfile extends BaseEntity<String> {
  final String username;
  String password;
  String displayName;
  String goalDescription;
  double weight;
  double height;
  int waterGlasses;

  UserProfile({
    required super.id,
    required this.username,
    required this.password,
    required String name,
    String description = 'Mục tiêu: Săn chắc cơ bắp & duy trì thể lực',
    required this.weight,
    required this.height,
    this.waterGlasses = 4,
  })  : displayName = name,
        goalDescription = description,
        super(name: name, description: description);

  @override
  String get name => displayName;

  @override
  String get description => goalDescription;

  double get bmiValue {
    if (height <= 0 || weight <= 0) return 0;
    return weight / (height * height);
  }

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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'name': displayName,
      'description': goalDescription,
      'weight': weight,
      'height': height,
      'waterGlasses': waterGlasses,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id']?.toString() ?? 'U001',
      username: map['username']?.toString() ?? '',
      password: map['password']?.toString() ?? '',
      name: map['name']?.toString() ?? 'Học viên',
      description: map['description']?.toString() ?? 'Thành viên PNP Fitness',
      weight: (map['weight'] as num?)?.toDouble() ?? 65.0,
      height: (map['height'] as num?)?.toDouble() ?? 1.70,
      waterGlasses: (map['waterGlasses'] as num?)?.toInt() ?? 0,
    );
  }
}