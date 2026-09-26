class UserProfile {
  String name;
  double weight;
  double height;

  UserProfile({required this.name, required this.weight, required this.height});

  String calculateBMI() {
    if (height <= 0 || weight <= 0) return "Dữ liệu không hợp lệ";
    
    double bmi = weight / (height * height);
    String status;
    
    if (bmi < 18.5) {
      status = "Thiếu cân";
    } else if (bmi >= 18.5 && bmi < 24.9) {
      status = "Bình thường";
    } else {
      status = "Thừa cân";
    }
    return "BMI: \({bmi.toStringAsFixed(1)} -\)status";
  }
}