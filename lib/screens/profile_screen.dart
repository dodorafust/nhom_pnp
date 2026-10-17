// File: lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../widgets/base_screen_layout.dart';

class ProfileScreen extends BaseScreenLayout<UserProfile> {
  const ProfileScreen({super.key});

  @override
  String get screenTitle => 'Hồ sơ Cá nhân (Phát)';

  @override
  IconData get screenIcon => Icons.person;

  @override
  UserProfile get screenData => const UserProfile(
        id: 'USER_01',
        name: 'Nguyễn Tấn Phát',
        description: 'Mục tiêu: Duy trì thể lực và săn chắc cơ bắp',
        weight: 68.0,
        height: 1.72,
      );

  @override
  Widget buildHeaderContent(BuildContext context, UserProfile data) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 28,
          backgroundColor: Colors.white,
          child: Icon(Icons.person, size: 32, color: Colors.teal),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.getBasicInfo(),
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                data.formatExtraNote<int>(2026),
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget buildMainContent(BuildContext context, UserProfile data) {
    return Column(
      children: [
        buildGenericItemCard<UserProfile>(
          item: data,
          leadingIcon: Icons.monitor_weight,
          title: 'Chỉ số Cân nặng & Chiều cao',
          subtitle: data.getDetailInfo(),
          trailingText: '${data.weight} kg',
        ),
        buildGenericItemCard<String>(
          item: data.calculateBMI(),
          leadingIcon: Icons.health_and_safety,
          title: 'Đánh giá chỉ số khối cơ thể (BMI)',
          subtitle: 'Công thức: Cân nặng / (Chiều cao x Chiều cao)',
          trailingText: data.bmiValue.toStringAsFixed(1),
        ),
      ],
    );
  }
}