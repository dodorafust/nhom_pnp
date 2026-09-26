import 'package:flutter/material.dart';
import '../models/user_profile.dart'; // Thay đổi đường dẫn này cho khớp với thư mục chứa file user_profile.dart của nhóm

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State {
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  String _bmiResult = '';

  void _onCalculatePressed() {
    double? h = double.tryParse(_heightController.text);
    double? w = double.tryParse(_weightController.text);

    if (h != null && w != null) {
      // Khởi tạo đối tượng và gọi hàm tính BMI
      UserProfile user = UserProfile(name: "Phát", weight: w, height: h);
      setState(() {
        _bmiResult = user.calculateBMI(); 
      });
    } else {
      setState(() {
        _bmiResult = "Vui lòng nhập số hợp lệ";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text('HÀNH TRÌNH CỦA BẠN', style: TextStyle(fontSize: 12, color: Colors.grey)),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text('Hồ sơ', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 16),
          // Khối thông tin cá nhân
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: const Color(0xFF1B2F2A), borderRadius: BorderRadius.circular(16)),
            child: Row(
              children: [
                const CircleAvatar(radius: 24, backgroundColor: Colors.white, child: Text('TL', style: TextStyle(color: Colors.teal))),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Phan Văn Phát', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    Text('Thành viên Active - Cấp 12', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
                const Spacer(),
                IconButton(onPressed: () {}, icon: const Icon(Icons.edit, color: Colors.white70)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Khối tính BMI
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text('Tính BMI', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _heightController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Chiều cao (m)',
                            prefixIcon: const Icon(Icons.height, color: Colors.teal),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: _weightController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Cân nặng (kg)',
                            prefixIcon: const Icon(Icons.scale, color: Colors.teal),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal, // Nút bấm màu xanh lơ[cite: 7]
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: _onCalculatePressed,
                      child: const Text('Tính chỉ số BMI', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_bmiResult.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.teal.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.teal),
                          const SizedBox(width: 8),
                          Expanded(child: Text(_bmiResult, style: const TextStyle(color: Colors.teal, fontWeight: FontWeight.bold))),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}