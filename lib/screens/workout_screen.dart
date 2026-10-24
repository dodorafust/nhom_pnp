// File: lib/screens/workout_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import '../models/exercise.dart';
import '../models/workout_session.dart';
import '../widgets/base_screen_layout.dart';

class WorkoutScreen extends BaseScreenLayout<WorkoutSession> {
  final WorkoutSession currentSession;
  final List<Exercise> allCatalogExercises;
  final List<String> workoutHistory;
  final VoidCallback onSessionChanged;
  final void Function(String newName, String newDesc) onEditSessionInfo;
  final VoidCallback onResetSessionProgress;
  final ValueChanged<String> onAddHistoryLog;
  final ValueChanged<int> onDeleteHistoryLog;

  const WorkoutScreen({
    super.key,
    required this.currentSession,
    required this.allCatalogExercises,
    required this.workoutHistory,
    required this.onSessionChanged,
    required this.onEditSessionInfo,
    required this.onResetSessionProgress,
    required this.onAddHistoryLog,
    required this.onDeleteHistoryLog,
  });

  @override
  String get screenTitle => 'Quản lý Buổi tập ';

  @override
  IconData get screenIcon => Icons.fitness_center;

  @override
  String get headerActionLabel => 'Sửa mục tiêu / Làm mới buổi tập';

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
  void onHeaderTap(BuildContext context, WorkoutSession data) {
    final nameCtrl = TextEditingController(text: data.name);
    final descCtrl = TextEditingController(text: data.description);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tùy chỉnh Buổi tập hôm nay'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Tên buổi tập',
                  prefixIcon: Icon(Icons.edit, color: Colors.teal),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descCtrl,
                decoration: const InputDecoration(
                  labelText: 'Mô tả / Mục tiêu buổi tập',
                  prefixIcon: Icon(Icons.flag, color: Colors.teal),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    onResetSessionProgress();
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Đã đặt lại tiến độ buổi tập về 0 để bắt đầu lượt mới!',
                        ),
                        backgroundColor: Colors.teal,
                      ),
                    );
                  },
                  icon: const Icon(Icons.restart_alt, color: Colors.orange),
                  label: const Text(
                    'Đặt lại toàn bộ bài tập về Chưa tập',
                    style: TextStyle(color: Colors.orange),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Đóng'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              if (nameCtrl.text.trim().isNotEmpty) {
                onEditSessionInfo(
                  nameCtrl.text.trim(),
                  descCtrl.text.trim(),
                );
              }
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Đã lưu thông tin buổi tập vào Database!'),
                  backgroundColor: Colors.teal,
                ),
              );
            },
            child: const Text('Lưu thay đổi'),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildMainContent(BuildContext context, WorkoutSession data) {
    return _WorkoutSessionTracker(
      session: data,
      allCatalogExercises: allCatalogExercises,
      workoutHistory: workoutHistory,
      onSessionChanged: onSessionChanged,
      onAddHistoryLog: onAddHistoryLog,
      onDeleteHistoryLog: onDeleteHistoryLog,
    );
  }
}

class _WorkoutSessionTracker extends StatefulWidget {
  final WorkoutSession session;
  final List<Exercise> allCatalogExercises;
  final List<String> workoutHistory;
  final VoidCallback onSessionChanged;
  final ValueChanged<String> onAddHistoryLog;
  final ValueChanged<int> onDeleteHistoryLog;

  const _WorkoutSessionTracker({
    required this.session,
    required this.allCatalogExercises,
    required this.workoutHistory,
    required this.onSessionChanged,
    required this.onAddHistoryLog,
    required this.onDeleteHistoryLog,
  });

  @override
  State<_WorkoutSessionTracker> createState() => _WorkoutSessionTrackerState();
}

class _WorkoutSessionTrackerState extends State<_WorkoutSessionTracker> {
  Timer? _timer;
  bool _isRunning = false;

  void _toggleTimer() {
    if (_isRunning) {
      _timer?.cancel();
      setState(() => _isRunning = false);
      widget.onSessionChanged();
    } else {
      setState(() => _isRunning = true);
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        setState(() {
          widget.session.elapsedSeconds++;
        });
        // Tự động lưu mỗi 5 giây khi đồng hồ chạy
        if (widget.session.elapsedSeconds % 5 == 0) {
          widget.onSessionChanged();
        }
      });
    }
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      widget.session.elapsedSeconds = 0;
    });
    widget.onSessionChanged();
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
        widget.onSessionChanged();
        return;
      }
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tuyệt vời! Bạn đã hoàn thành tất cả bài tập hôm nay!'),
        backgroundColor: Colors.teal,
      ),
    );
  }

  void _saveWorkoutHistory() {
    final completed = widget.session.completedCount;
    final total = widget.session.exercises.length;
    final burned =
        widget.session.calculateCompletedCalories().toStringAsFixed(0);
    final duration = _formatDuration(widget.session.elapsedSeconds);
    final now = DateTime.now();
    final timeStr =
        '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')} (${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')})';

    final logEntry =
        '$timeStr • Thời lượng $duration • Đã tập $completed/$total bài ($burned kcal)';
    widget.onAddHistoryLog(logEntry);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã lưu kết quả buổi tập vào Database Lịch sử!'),
        backgroundColor: Colors.teal,
      ),
    );
  }

  void _showAddExerciseToSessionSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Chọn bài tập thêm vào Buổi tập hôm nay',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.allCatalogExercises.length,
                  itemBuilder: (context, index) {
                    final ex = widget.allCatalogExercises[index];
                    final alreadyIn = widget.session.exercises
                        .any((item) => item.id == ex.id);
                    return ListTile(
                      leading: const Icon(
                        Icons.fitness_center,
                        color: Colors.teal,
                      ),
                      title: Text(ex.name),
                      subtitle: Text(ex.getDetailInfo()),
                      trailing: alreadyIn
                          ? const Chip(label: Text('Đã có'))
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  widget.session.addExercise(ex.copyWith());
                                });
                                widget.onSessionChanged();
                                Navigator.pop(ctx);
                              },
                              child: const Text('Thêm'),
                            ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
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
        // Khối hiển thị tiến độ buổi tập
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
                    'ĐÃ HOÀN THÀNH (LƯU TỰ ĐỘNG)',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
                    '/$totalExercises bài',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      height: 2,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    _formatDuration(widget.session.elapsedSeconds),
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
        const SizedBox(height: 18),

        // Thanh công cụ danh sách bài tập trong buổi
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Bài tập trong buổi hôm nay:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                TextButton.icon(
                  onPressed: _showAddExerciseToSessionSheet,
                  icon: const Icon(Icons.add_circle_outline,
                      size: 18, color: Colors.teal),
                  label: const Text(
                    'Thêm bài',
                    style: TextStyle(color: Colors.teal),
                  ),
                ),
                TextButton.icon(
                  onPressed: _saveWorkoutHistory,
                  icon: const Icon(Icons.save, size: 18, color: Colors.teal),
                  label: const Text(
                    'Lưu lịch sử',
                    style: TextStyle(color: Colors.teal),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (widget.session.exercises.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Center(
                child: Text(
                  'Chưa có bài tập nào. Hãy bấm "Thêm bài" hoặc chọn từ Tab Bài tập!',
                ),
              ),
            ),
          )
        else
          ...widget.session.exercises.asMap().entries.map((entry) {
            final idx = entry.key;
            final ex = entry.value;
            return Card(
              elevation: 1.5,
              margin: const EdgeInsets.only(bottom: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Checkbox(
                  value: ex.isCompleted,
                  activeColor: Colors.teal,
                  onChanged: (val) {
                    setState(() => ex.isCompleted = val ?? false);
                    widget.onSessionChanged();
                  },
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
                trailing: IconButton(
                  icon: const Icon(Icons.close, size: 20, color: Colors.grey),
                  tooltip: 'Xóa khỏi buổi tập',
                  onPressed: () {
                    setState(() {
                      widget.session.exercises.removeAt(idx);
                    });
                    widget.onSessionChanged();
                  },
                ),
                onTap: () {
                  setState(() => ex.isCompleted = !ex.isCompleted);
                  widget.onSessionChanged();
                },
              ),
            );
          }),
        const SizedBox(height: 16),
        const Text(
          'Lịch sử các buổi tập đã lưu (Database):',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...widget.workoutHistory.asMap().entries.map(
              (entry) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  dense: true,
                  leading: const Icon(Icons.history, color: Colors.teal),
                  title: Text(entry.value),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline,
                        size: 18, color: Colors.redAccent),
                    onPressed: () => widget.onDeleteHistoryLog(entry.key),
                  ),
                ),
              ),
            ),
      ],
    );
  }
}