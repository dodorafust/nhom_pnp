import 'package:flutter/material.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  int _exerciseCount = 0; // Tái sử dụng biến đếm[cite: 7]
  final int _totalExercises = 7;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('NỘI DUNG CHÍNH', style: TextStyle(fontSize: 12, color: Colors.grey)),
          const Text('Buổi tập hôm nay', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          // Khối giao diện hiển thị tiến trình
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1B2F2A), // Màu xanh đen như bản thiết kế
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('ĐÃ HOÀN THÀNH', style: TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('$_exerciseCount', style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                    Text('/$_totalExercises bài', style: const TextStyle(color: Colors.white70, fontSize: 16, height: 2)),
                  ],
                ),
                const SizedBox(height: 16),
                LinearProgressIndicator(
                  value: _exerciseCount / _totalExercises,
                  backgroundColor: Colors.white24,
                  color: Colors.tealAccent,
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // Nút bấm tăng biến đếm
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                if (_exerciseCount < _totalExercises) {
                  setState(() => _exerciseCount++); // Tăng biến đếm để cập nhật màn hình[cite: 7]
                }
              },
              icon: const Icon(Icons.check, color: Colors.white),
              label: const Text('Hoàn tất 1 bài', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal, // Sử dụng màu xanh lơ[cite: 7]
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}