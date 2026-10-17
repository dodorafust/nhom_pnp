import 'package:flutter/material.dart';

class ExerciseScreen extends StatelessWidget {
  const ExerciseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildExerciseCard('Goblet Squat', 'Chân • Mông', '4 hiệp x 12'),
          _buildExerciseCard('Hít đất nâng cao', 'Ngực • Tay sau', '3 hiệp x 10'),
          _buildExerciseCard('Kéo tạ một tay', 'Lưng • Xô', '3 hiệp x 12'),
          _buildExerciseCard('Plank chạm vai', 'Bụng • Vai', '3 hiệp x 45s'),
        ],
      ),
    );
  }

  // Hàm hỗ trợ tạo Card giao diện cho ngắn gọn
  Widget _buildExerciseCard(String title, String subtitle, String reps) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.teal.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.fitness_center, color: Colors.teal),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('\(subtitle\n\)reps'),
        isThreeLine: true,
        trailing: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal.shade50,
            elevation: 0,
          ),
          child: const Text('Chi tiết', style: TextStyle(color: Colors.teal)),
        ),
      ),
    );
  }
}