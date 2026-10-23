// File: lib/screens/workout_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import '../models/workout_session.dart';
import '../widgets/base_screen_layout.dart';

class WorkoutScreen extends BaseScreenLayout<WorkoutSession> {
  final WorkoutSession currentSession;
  final VoidCallback onSessionUpdated;

  const WorkoutScreen({
    super.key,
    required this.currentSession,
    required this.onSessionUpdated,
  });

  @override
  String get screenTitle => 'Quản lý Buổi tập (Phong)';

  @override
  IconData get screenIcon => Icons.fitness_center;

  @override
  WorkoutSession get screenData => currentSession;

  @override
  Widget buildHeaderContent(BuildContext context, WorkoutSession data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          data.getBasicInfo(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          data.getDetailInfo(),
          style: const TextStyle(color: Colors.white70, fontSize: 13),
        ),
      ],
    );
  }

  @override
  Widget buildMainContent(BuildContext context, WorkoutSession data) {
    return _WorkoutSessionTracker(
      session: data,
      onSessionUpdated: onSessionUpdated,
    );
  }
}

class _WorkoutSessionTracker extends StatefulWidget {
  final WorkoutSession session;
  final VoidCallback onSessionUpdated;

  const _WorkoutSessionTracker({
    required this.session,
    required this.onSessionUpdated,
  });

  @override
  State<_WorkoutSessionTracker> createState() => _WorkoutSessionTrackerState();
}

class _WorkoutSessionTrackerState extends State<_WorkoutSessionTracker> {
  Timer? _timer;
  int _secondsElapsed = 0;
  bool _isRunning = false;
  final List<String> _workoutHistory = [
    'Hôm qua • Full Body (420 kcal - Hoàn thành 100%)',
  ];

  void _toggleTimer() {
    if (_isRunning) {
      _timer?.cancel();
      setState(() => _isRunning = false);
    } else {
      setState(() => _isRunning = true);
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        setState(() => _secondsElapsed++);
      });
    }
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _secondsElapsed = 0;
    });
  }

  String _formatDuration(int totalSeconds) {
    final mins = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final secs = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  void _completeNextExercise() {
    for (var ex in widget.session.exercises) {
      if (!ex.isCompleted) {
        setState(() => ex.isCompleted = true);
        widget.onSessionUpdated();
        return;
      }
    }
  }

  void _saveWorkoutHistory() {
    final completed = widget.session.completedCount;
    final total = widget.session.exercises.length;
    final burned = widget.session.calculateCompletedCalories().toStringAsFixed(0);
    final duration = _formatDuration(_secondsElapsed);

    setState(() {
      _workoutHistory.insert(
        0,
        'Hôm nay ($duration) • Đã tập $completed/$total bài ($burned kcal)',
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã lưu kết quả buổi tập vào lịch sử!'),
        backgroundColor: Colors.teal,
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalExercises = widget.session.exercises.length;
    final exerciseCount = widget.session.completedCount;
    final progress = totalExercises == 0 ? 0.0 : exerciseCount / totalExercises;
    final burnedCalories = widget.session.calculateCompletedCalories();
    final totalCalories = widget.session.calculateTotalCalories();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Khối hiển thị tiến độ buổi tập (Màu xanh đen chuẩn Wireframe của Phong)
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF1B2F2A),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'TIẾN ĐỘ BUỔI TẬP HÔM NAY',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.teal.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${burnedCalories.toStringAsFixed(0)} / ${totalCalories.toStringAsFixed(0)} kcal',
                      style: const TextStyle(
                        color: Colors.tealAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$exerciseCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '/$totalExercises bài đã xong',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      height: 2,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    _formatDuration(_secondsElapsed),
                    style: const TextStyle(
                      color: Colors.tealAccent,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.white24,
                color: Colors.tealAccent,
                minHeight: 8,
                borderRadius: BorderRadius.circular(6),
              ),
              const SizedBox(height: 16),
              // Hàng nút điều khiển Đồng hồ bấm giờ & Hoàn tất nhanh
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _toggleTimer,
                      icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                      label: Text(_isRunning ? 'Tạm dừng' : 'Bắt đầu tập'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _isRunning ? Colors.amber.shade700 : Colors.teal,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _resetTimer,
                    icon: const Icon(Icons.refresh, color: Colors.white70),
                    tooltip: 'Đặt lại đồng hồ',
                  ),
                  const SizedBox(width: 4),
                  ElevatedButton.icon(
                    onPressed: _completeNextExercise,
                    icon: const Icon(Icons.check),
                    label: const Text('Hoàn tất 1 bài'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.tealAccent.shade700,
                      foregroundColor: Colors.black87,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Danh sách bài tập trong buổi
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Danh sách bài tập trong buổi:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextButton.icon(
              onPressed: _saveWorkoutHistory,
              icon: const Icon(Icons.save, size: 18, color: Colors.teal),
              label: const Text('Lưu lịch sử', style: TextStyle(color: Colors.teal)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...widget.session.exercises.map((ex) {
          return Card(
            elevation: 1.5,
            margin: const EdgeInsets.only(bottom: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: CheckboxListTile(
              value: ex.isCompleted,
              activeColor: Colors.teal,
              onChanged: (val) {
                setState(() => ex.isCompleted = val ?? false);
                widget.onSessionUpdated();
              },
              secondary: CircleAvatar(
                backgroundColor: ex.isCompleted
                    ? Colors.teal.withValues(alpha: 0.2)
                    : Colors.grey.withValues(alpha: 0.15),
                child: Icon(
                  ex.isCompleted ? Icons.check_circle : Icons.timer,
                  color: ex.isCompleted ? Colors.teal : Colors.grey,
                ),
              ),
              title: Text(
                ex.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration:
                      ex.isCompleted ? TextDecoration.lineThrough : null,
                ),
              ),
              subtitle: Text(
                '${ex.setsAndReps} • ${ex.getBurnedCalories().toStringAsFixed(0)} kcal',
              ),
            ),
          );
        }),
        const SizedBox(height: 16),
        const Text(
          'Lịch sử các buổi tập gần đây:',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ..._workoutHistory.map(
          (item) => Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              dense: true,
              leading: const Icon(Icons.history, color: Colors.teal),
              title: Text(item),
            ),
          ),
        ),
      ],
    );
  }
}