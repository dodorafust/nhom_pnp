// File: lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../widgets/base_screen_layout.dart';

class ProfileScreen extends BaseScreenLayout<UserProfile> {
  final UserProfile userProfile;
  final bool isDarkMode;
  final VoidCallback onToggleTheme;
  final VoidCallback onProfileUpdated;

  const ProfileScreen({
    super.key,
    required this.userProfile,
    required this.isDarkMode,
    required this.onToggleTheme,
    required this.onProfileUpdated,
  });

  @override
  String get screenTitle => 'Hồ sơ Cá nhân (Phát)';

  @override
  IconData get screenIcon => Icons.person;

  @override
  UserProfile get screenData => userProfile;

  @override
  List<Widget>? buildAppBarActions(BuildContext context) {
    return [
      IconButton(
        onPressed: onToggleTheme,
        icon: Icon(
          isDarkMode ? Icons.light_mode : Icons.dark_mode,
          color: Colors.white,
        ),
        tooltip: 'Đổi giao diện Sáng/Tối',
      ),
    ];
  }

  @override
  Widget buildHeaderContent(BuildContext context, UserProfile data) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 30,
          backgroundColor: Colors.white,
          child: Text(
            'PNP',
            style: TextStyle(
              color: Colors.teal,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.getBasicInfo(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                data.formatExtraNote<String>('Thành viên Active - Cấp 12'),
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
    return _InteractiveProfileBody(
      profile: data,
      onProfileUpdated: onProfileUpdated,
    );
  }
}

class _InteractiveProfileBody extends StatefulWidget {
  final UserProfile profile;
  final VoidCallback onProfileUpdated;

  const _InteractiveProfileBody({
    required this.profile,
    required this.onProfileUpdated,
  });

  @override
  State<_InteractiveProfileBody> createState() =>
      _InteractiveProfileBodyState();
}

class _InteractiveProfileBodyState extends State<_InteractiveProfileBody> {
  late final TextEditingController _heightController;
  late final TextEditingController _weightController;
  late String _bmiResult;

  @override
  void initState() {
    super.initState();
    _heightController =
        TextEditingController(text: widget.profile.height.toString());
    _weightController =
        TextEditingController(text: widget.profile.weight.toString());
    _bmiResult = widget.profile.calculateBMI();
  }

  void _onCalculatePressed() {
    final h = double.tryParse(_heightController.text);
    final w = double.tryParse(_weightController.text);

    if (h != null && w != null && h > 0 && w > 0) {
      setState(() {
        widget.profile.height = h;
        widget.profile.weight = w;
        _bmiResult = widget.profile.calculateBMI();
      });
      widget.onProfileUpdated();
    } else {
      setState(() {
        _bmiResult = 'Vui lòng nhập chiều cao (m) và cân nặng (kg) hợp lệ';
      });
    }
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. Khối công cụ tính BMI
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.monitor_weight, color: Colors.teal),
                    SizedBox(width: 8),
                    Text(
                      'Công cụ tính chỉ số khối cơ thể (BMI)',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _heightController,
                        keyboardType:
                            const TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          labelText: 'Chiều cao (m)',
                          prefixIcon:
                              const Icon(Icons.height, color: Colors.teal),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _weightController,
                        keyboardType:
                            const TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          labelText: 'Cân nặng (kg)',
                          prefixIcon:
                              const Icon(Icons.scale, color: Colors.teal),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: _onCalculatePressed,
                    icon: const Icon(Icons.calculate),
                    label: const Text(
                      'Tính chỉ số BMI',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.teal.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.teal),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _bmiResult,
                          style: const TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // 2. Khối theo dõi lượng nước uống trong ngày (Water Tracker)
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.water_drop, color: Colors.blue),
                    const SizedBox(width: 8),
                    const Text(
                      'Theo dõi lượng nước uống',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const Spacer(),
                    Text(
                      '${widget.profile.waterGlasses} / 8 cốc (2L)',
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: (widget.profile.waterGlasses / 8).clamp(0.0, 1.0),
                  backgroundColor: Colors.blue.withValues(alpha: 0.15),
                  color: Colors.blue,
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(6),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {
                        if (widget.profile.waterGlasses > 0) {
                          setState(() => widget.profile.waterGlasses--);
                        }
                      },
                      icon: const Icon(Icons.remove, size: 18),
                      label: const Text('Bớt 1 cốc'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() => widget.profile.waterGlasses++);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Uống 1 cốc (250ml)'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // 3. Khối thông tin thành viên nhóm nhom_pnp
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 2,
          child: const Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Thành viên thực hiện (Repo: dodorafust/nhom_pnp)',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Divider(),
                ListTile(
                  dense: true,
                  leading: Icon(Icons.person_pin, color: Colors.teal),
                  title: Text('Phan Văn Phát - MSSV: 23017073'),
                  subtitle: Text('Phụ trách: UserProfile & Màn hình Hồ sơ BMI'),
                ),
                ListTile(
                  dense: true,
                  leading: Icon(Icons.person_pin, color: Colors.teal),
                  title: Text('Nguyễn Hoàng Phong - MSSV: 23010247'),
                  subtitle: Text('Phụ trách: WorkoutSession & Màn hình Buổi tập'),
                ),
                ListTile(
                  dense: true,
                  leading: Icon(Icons.person_pin, color: Colors.teal),
                  title: Text('Hoàng Hải Nam - MSSV: 23017272'),
                  subtitle: Text('Phụ trách: Exercise & Màn hình Bài tập'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}