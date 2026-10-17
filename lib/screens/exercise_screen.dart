// File: lib/screens/exercise_screen.dart
import 'package:flutter/material.dart';
import '../models/base_entity.dart';
import '../models/exercise.dart';
import '../widgets/base_screen_layout.dart';

class ExerciseScreen extends BaseScreenLayout<EntityCollection<Exercise>> {
  const ExerciseScreen({super.key});

  @override
  String get screenTitle => 'Danh sách Bài tập (Nam)';

  @override
  IconData get screenIcon => Icons.list_alt;

  @override
  EntityCollection<Exercise> get screenData => EntityCollection<Exercise>(
        items: const [
          Exercise(
            id: 'EX01',
            name: 'Chạy bộ buổi sáng',
            description: 'Tăng cường sức bền tim mạch',
            durationInMinutes: 30,
            caloriesPerMinute: 10.5,
          ),
          Exercise(
            id: 'EX02',
            name: 'Hít đất nâng cao',
            description: 'Phát triển cơ ngực và tay sau',
            durationInMinutes: 15,
            caloriesPerMinute: 8.0,
          ),
          Exercise(
            id: 'EX03',
            name: 'Plank siết cơ bụng',
            description: 'Giữ thẳng lưng và siết chặt cơ trọng tâm',
            durationInMinutes: 10,
            caloriesPerMinute: 6.5,
          ),
        ],
      );

  @override
  Widget buildHeaderContent(BuildContext context, EntityCollection<Exercise> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'THƯ VIỆN BÀI TẬP',
          style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          'Tổng số bài tập hiện có: ${data.totalCount} bài',
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  @override
  Widget buildMainContent(BuildContext context, EntityCollection<Exercise> data) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: data.items.length,
      itemBuilder: (context, index) {
        final ex = data.items[index];
        return buildGenericItemCard<Exercise>(
          item: ex,
          leadingIcon: Icons.fitness_center,
          title: ex.getBasicInfo(),
          subtitle: '${ex.getDetailInfo()}\n${ex.formatExtraNote<String>("Mức độ: Tiêu chuẩn")}',
          trailingText: '${ex.getBurnedCalories().toStringAsFixed(0)} kcal',
        );
      },
    );
  }
}