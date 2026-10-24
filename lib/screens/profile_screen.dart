// File: lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../services/database_service.dart';
import '../widgets/base_screen_layout.dart';

class ProfileScreen extends BaseScreenLayout<UserProfile> {
  final UserProfile userProfile;
  final bool isDarkMode;
  final VoidCallback onToggleTheme;
  final VoidCallback onProfileUpdated;
  final VoidCallback onLogout;

  const ProfileScreen({
    super.key,
    required this.userProfile,
    required this.isDarkMode,
    required this.onToggleTheme,
    required this.onProfileUpdated,
    required this.onLogout,
  });

  @override
  String get screenTitle => 'Hồ sơ Cá nhân ';

  @override
  IconData get screenIcon => Icons.person;

  @override
  String get headerActionLabel => 'Chỉnh sửa Hồ sơ & Mục tiêu';

  @override
  UserProfile get screenData => userProfile;

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận Đăng xuất'),
        content: Text(
          'Bạn có chắc chắn muốn đăng xuất khỏi tài khoản "${userProfile.username}" không?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              onLogout();
            },
            child: const Text('Đăng xuất'),
          ),
        ],
      ),
    );
  }

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
      IconButton(
        onPressed: () => _confirmLogout(context),
        icon: const Icon(Icons.logout, color: Colors.white),
        tooltip: 'Đăng xuất tài khoản',
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
          child: Icon(Icons.person, size: 32, color: Colors.teal),
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
                data.formatExtraNote<String>(
                  'Tài khoản: @${data.username} • ${data.calculateBMI()}',
                ),
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void onHeaderTap(BuildContext context, UserProfile data) {
    final nameCtrl = TextEditingController(text: data.displayName);
    final goalCtrl = TextEditingController(text: data.goalDescription);
    final passCtrl = TextEditingController(text: data.password);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Chỉnh sửa Hồ sơ Cá nhân'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Họ và tên hiển thị',
                  prefixIcon: Icon(Icons.badge, color: Colors.teal),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: goalCtrl,
                decoration: const InputDecoration(
                  labelText: 'Mục tiêu tập luyện cá nhân',
                  prefixIcon: Icon(Icons.flag, color: Colors.teal),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: passCtrl,
                decoration: const InputDecoration(
                  labelText: 'Mật khẩu đăng nhập',
                  prefixIcon: Icon(Icons.lock, color: Colors.teal),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              if (nameCtrl.text.trim().isNotEmpty) {
                data.displayName = nameCtrl.text.trim();
              }
              if (goalCtrl.text.trim().isNotEmpty) {
                data.goalDescription = goalCtrl.text.trim();
              }
              if (passCtrl.text.trim().isNotEmpty) {
                data.password = passCtrl.text.trim();
              }
              await DatabaseService.updateUserProfile(data);
              onProfileUpdated();
              if (!ctx.mounted) return;
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Đã cập nhật hồ sơ cá nhân vào Database!'),
                  backgroundColor: Colors.teal,
                ),
              );
            },
            child: const Text('Lưu hồ sơ'),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildMainContent(BuildContext context, UserProfile data) {
    return _InteractiveProfileBody(
      profile: data,
      onProfileUpdated: onProfileUpdated,
      onLogoutPressed: () => _confirmLogout(context),
    );
  }
}

class _InteractiveProfileBody extends StatefulWidget {
  final UserProfile profile;
  final VoidCallback onProfileUpdated;
  final VoidCallback onLogoutPressed;

  const _InteractiveProfileBody({
    required this.profile,
    required this.onProfileUpdated,
    required this.onLogoutPressed,
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

  Future<void> _onCalculatePressed() async {
    final h = double.tryParse(_heightController.text);
    final w = double.tryParse(_weightController.text);

    if (h != null && w != null && h > 0 && w > 0) {
      setState(() {
        widget.profile.height = h;
        widget.profile.weight = w;
        _bmiResult = widget.profile.calculateBMI();
      });
      await DatabaseService.updateUserProfile(widget.profile);
      widget.onProfileUpdated();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã tính BMI và lưu thông tin vào Database!'),
          backgroundColor: Colors.teal,
        ),
      );
    } else {
      setState(() {
        _bmiResult = 'Vui lòng nhập chiều cao (m) và cân nặng (kg) hợp lệ';
      });
    }
  }

  Future<void> _updateWater(int delta) async {
    final nextVal = widget.profile.waterGlasses + delta;
    if (nextVal < 0) return;
    setState(() {
      widget.profile.waterGlasses = nextVal;
    });
    await DatabaseService.updateUserProfile(widget.profile);
    widget.onProfileUpdated();
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
        Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _heightController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
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
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
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
                      'Tính chỉ số BMI & Lưu Database',
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
        Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                      onPressed: () => _updateWater(-1),
                      icon: const Icon(Icons.remove, size: 18),
                      label: const Text('Bớt 1 cốc'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: () => _updateWater(1),
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
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: widget.onLogoutPressed,
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            label: const Text(
              'ĐĂNG XUẤT TÀI KHOẢN',
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.redAccent, width: 1.5),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}