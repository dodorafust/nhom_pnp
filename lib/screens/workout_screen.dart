// File: lib/screens/workout_screen.dart
import 'package:flutter/material.dart';
import '../models/exercise.dart';
import '../models/workout_session.dart';
import '../widgets/base_screen_layout.dart';

class WorkoutScreen extends BaseScreenLayout<WorkoutSession> {
  const WorkoutScreen({super.key});

  @override
  String get screenTitle => 'Quản lý Buổi tập';

  @override
  IconData get screenIcon => Icons.fitness_center;

  @override
  WorkoutSession get screenData => const WorkoutSession(
        id: 101,
        name: 'Buổi tập Full Body đốt mỡ',
        description: 'Kết hợp Cardio và kháng lực cường độ cao',
        date: '17/10/2026',
        exercises: [
          Exercise(
            id: 'EX01',
            name: 'Chạy bộ khởi động',
            description: 'Làm nóng khớp và nhịp tim',
            durationInMinutes: 15,
            caloriesPerMinute: 10.0,
          ),
          Exercise(
            id: 'EX02',
            name: 'Squat gánh tạ',
            description: 'Tập trung cơ đùi trước và mông',
            durationInMinutes: 25,
            caloriesPerMinute: 9.5,
          ),
        ],
      );

  @override
  Widget buildHeaderContent(BuildContext context, WorkoutSession data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          data.getBasicInfo(),
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Text(
          data.getDetailInfo(),
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
      ],
    );
  }

  @override
  Widget buildMainContent(BuildContext context, WorkoutSession data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: Text(
            'Các bài tập trong buổi:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        ...data.exercises.map(
          (ex) => buildGenericItemCard<Exercise>(
            item: ex,
            leadingIcon: Icons.timer,
            title: ex.getBasicInfo(),
            subtitle: ex.getDetailInfo(),
            trailingText: '${ex.durationInMinutes} phút',
          ),
        ),
      ],
    );
  }
}