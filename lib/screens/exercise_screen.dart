// File: lib/screens/exercise_screen.dart
import 'package:flutter/material.dart';
import '../models/base_entity.dart';
import '../models/exercise.dart';
import '../widgets/base_screen_layout.dart';

class ExerciseScreen extends BaseScreenLayout<EntityCollection<Exercise>> {
  final List<Exercise> exercises;
  final ValueChanged<Exercise> onAddExercise;
  final ValueChanged<Exercise> onUpdateExercise;
  final ValueChanged<String> onDeleteExercise;
  final ValueChanged<Exercise> onSendToWorkout;
  final void Function(String planName, List<Exercise> selectedExercises)
      onApplyChallengePlan;
  final VoidCallback onResetDefaultExercises;

  const ExerciseScreen({
    super.key,
    required this.exercises,
    required this.onAddExercise,
    required this.onUpdateExercise,
    required this.onDeleteExercise,
    required this.onSendToWorkout,
    required this.onApplyChallengePlan,
    required this.onResetDefaultExercises,
  });

  @override
  String get screenTitle => 'Thư viện Bài tập ';

  @override
  IconData get screenIcon => Icons.list_alt;

  @override
  String get headerActionLabel => 'Chọn gói Thử thách 30 ngày';

  @override
  EntityCollection<Exercise> get screenData =>
      EntityCollection<Exercise>(items: exercises);

  @override
  Widget buildHeaderContent(
    BuildContext context,
    EntityCollection<Exercise> data,
  ) {
    final totalCalories = data.items.fold<double>(
      0,
      (sum, item) => sum + item.getBurnedCalories(),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            '🔥 HOT • THỬ THÁCH 30 NGÀY',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Kho bài tập: ${data.totalCount} bài (${totalCalories.toStringAsFixed(0)} kcal)',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Chạm vào khung này để áp dụng nhanh gói bài tập mẫu vào Buổi tập hôm nay.',
          style: TextStyle(color: Colors.white70, fontSize: 13),
        ),
      ],
    );
  }

  @override
  void onHeaderTap(BuildContext context, EntityCollection<Exercise> data) {
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
              const Row(
                children: [
                  Icon(Icons.local_fire_department, color: Colors.orange, size: 28),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Chương trình Thử thách 30 Ngày',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                'Chọn một lộ trình dưới đây để tự động nạp danh sách bài tập sang Tab Buổi tập hôm nay (và lưu vào Database):',
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const SizedBox(height: 14),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.orange,
                  child: Icon(Icons.bolt, color: Colors.white),
                ),
                title: const Text(
                  'Gói 1: Đốt mỡ toàn thân cấp tốc (HIIT & Core)',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text('Gồm các bài Cardio, Bụng và Chân tiêu hao nhiều Calo'),
                onTap: () {
                  final list = data.items
                      .where((e) =>
                          e.category == 'Cardio' ||
                          e.category == 'Bụng' ||
                          e.category == 'Chân')
                      .toList();
                  onApplyChallengePlan(
                    'Thử thách Đốt mỡ cấp tốc',
                    list.isNotEmpty ? list : data.items,
                  );
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Đã nạp gói "Đốt mỡ cấp tốc" vào Buổi tập hôm nay!'),
                      backgroundColor: Colors.teal,
                    ),
                  );
                },
              ),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.teal,
                  child: Icon(Icons.fitness_center, color: Colors.white),
                ),
                title: const Text(
                  'Gói 2: Tăng cơ thân trên (Ngực - Lưng - Bụng)',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text('Tập trung kháng lực phát triển cơ ngực, vai và lưng xô'),
                onTap: () {
                  final list = data.items
                      .where((e) =>
                          e.category == 'Ngực' ||
                          e.category == 'Lưng' ||
                          e.category == 'Bụng')
                      .toList();
                  onApplyChallengePlan(
                    'Thử thách Tăng cơ thân trên',
                    list.isNotEmpty ? list : data.items,
                  );
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Đã nạp gói "Tăng cơ thân trên" vào Buổi tập hôm nay!'),
                      backgroundColor: Colors.teal,
                    ),
                  );
                },
              ),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.all_inclusive, color: Colors.white),
                ),
                title: const Text(
                  'Gói 3: Toàn bộ bài tập trong thư viện (Full Routine)',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('Nạp toàn bộ ${data.totalCount} bài tập hiện có vào buổi tập'),
                onTap: () {
                  onApplyChallengePlan('Thử thách Full Body 30 Ngày', data.items);
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Đã nạp toàn bộ bài tập vào Buổi tập hôm nay!'),
                      backgroundColor: Colors.teal,
                    ),
                  );
                },
              ),
              const Divider(),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () {
                    onResetDefaultExercises();
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Đã khôi phục 5 bài tập gốc vào Database!'),
                        backgroundColor: Colors.teal,
                      ),
                    );
                  },
                  icon: const Icon(Icons.restore, color: Colors.redAccent),
                  label: const Text(
                    'Khôi phục thư viện bài tập mặc định',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget buildMainContent(
    BuildContext context,
    EntityCollection<Exercise> data,
  ) {
    return _InteractiveExerciseCatalog(
      exercises: data.items,
      onAddExercise: onAddExercise,
      onUpdateExercise: onUpdateExercise,
      onDeleteExercise: onDeleteExercise,
      onSendToWorkout: onSendToWorkout,
    );
  }
}

class _InteractiveExerciseCatalog extends StatefulWidget {
  final List<Exercise> exercises;
  final ValueChanged<Exercise> onAddExercise;
  final ValueChanged<Exercise> onUpdateExercise;
  final ValueChanged<String> onDeleteExercise;
  final ValueChanged<Exercise> onSendToWorkout;

  const _InteractiveExerciseCatalog({
    required this.exercises,
    required this.onAddExercise,
    required this.onUpdateExercise,
    required this.onDeleteExercise,
    required this.onSendToWorkout,
  });

  @override
  State<_InteractiveExerciseCatalog> createState() =>
      _InteractiveExerciseCatalogState();
}

class _InteractiveExerciseCatalogState
    extends State<_InteractiveExerciseCatalog> {
  String _searchQuery = '';
  String _selectedCategory = 'Tất cả';

  final List<String> _categories = const [
    'Tất cả',
    'Ngực',
    'Lưng',
    'Chân',
    'Bụng',
    'Cardio',
  ];

  List<Exercise> get _filteredExercises {
    return widget.exercises.where((ex) {
      final matchesCategory =
          _selectedCategory == 'Tất cả' || ex.category == _selectedCategory;
      final matchesSearch =
          ex.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              ex.description.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  void _showAddExerciseDialog() {
    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final durationCtrl = TextEditingController(text: '15');
    final calCtrl = TextEditingController(text: '8.5');
    final setsCtrl = TextEditingController(text: '3 hiệp x 12 lần');
    String selectedCat = 'Ngực';

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Thêm Bài Tập Mới'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Tên bài tập (*)',
                      ),
                    ),
                    TextField(
                      controller: descCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Mô tả kỹ thuật',
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: selectedCat,
                      decoration: const InputDecoration(labelText: 'Nhóm cơ'),
                      items: _categories
                          .where((c) => c != 'Tất cả')
                          .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setDialogState(() => selectedCat = val);
                        }
                      },
                    ),
                    TextField(
                      controller: setsCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Số hiệp x Số lần',
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: durationCtrl,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Thời gian (phút)',
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: calCtrl,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Calo/phút',
                            ),
                          ),
                        ),
                      ],
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
                  onPressed: () {
                    if (nameCtrl.text.trim().isEmpty) return;
                    final newEx = Exercise(
                      id: 'EX${DateTime.now().millisecondsSinceEpoch.toString().substring(9)}',
                      name: nameCtrl.text.trim(),
                      description: descCtrl.text.trim().isEmpty
                          ? 'Bài tập cá nhân tự thiết kế'
                          : descCtrl.text.trim(),
                      durationInMinutes: int.tryParse(durationCtrl.text) ?? 15,
                      caloriesPerMinute: double.tryParse(calCtrl.text) ?? 8.0,
                      category: selectedCat,
                      setsAndReps: setsCtrl.text.trim(),
                    );
                    widget.onAddExercise(newEx);
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(this.context).showSnackBar(
                      SnackBar(
                        content: Text('Đã lưu bài tập "${newEx.name}" vào Database!'),
                        backgroundColor: Colors.teal,
                      ),
                    );
                  },
                  child: const Text('Lưu vào Database'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showExerciseDetailModal(Exercise ex) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.teal.withValues(alpha: 0.15),
                    child: const Icon(Icons.fitness_center, color: Colors.teal),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ex.getBasicInfo(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          ex.getDetailInfo(),
                          style: const TextStyle(color: Colors.teal),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      widget.onDeleteExercise(ex.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Đã xóa "${ex.name}" khỏi Database.'),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                    },
                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                    tooltip: 'Xóa bài tập này',
                  ),
                ],
              ),
              const Divider(height: 28),
              Text(
                ex.formatExtraNote<String>(
                  'Giữ nhịp thở đều và kiểm soát chuyển động',
                ),
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 20),
              const Text(
                'Đánh giá độ hiệu quả (Tự động lưu vào Database):',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ReviewWidget(
                initialRating: ex.rating,
                onRatingChanged: (newRating) {
                  setState(() => ex.rating = newRating);
                  widget.onUpdateExercise(ex);
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    widget.onSendToWorkout(ex);
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Đã thêm & lưu "${ex.name}" vào Buổi tập hôm nay!',
                        ),
                        backgroundColor: Colors.teal,
                      ),
                    );
                  },
                  icon: const Icon(Icons.playlist_add_check),
                  label: const Text('Thêm vào Buổi tập hôm nay'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = _filteredExercises;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                onChanged: (val) => setState(() => _searchQuery = val),
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm bài tập...',
                  prefixIcon: const Icon(Icons.search, color: Colors.teal),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton.icon(
              onPressed: _showAddExerciseDialog,
              icon: const Icon(Icons.add),
              label: const Text('Thêm bài'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _categories.map((cat) {
              final isSelected = _selectedCategory == cat;
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ChoiceChip(
                  label: Text(cat),
                  selected: isSelected,
                  selectedColor: Colors.teal,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : null,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  onSelected: (_) => setState(() => _selectedCategory = cat),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 14),
        if (list.isEmpty)
          const Padding(
            padding: EdgeInsets.all(24.0),
            child: Center(
              child: Text('Không tìm thấy bài tập phù hợp.'),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: list.length,
            itemBuilder: (context, index) {
              final ex = list[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: ListTile(
                  onTap: () => _showExerciseDetailModal(ex),
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.teal.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.fitness_center, color: Colors.teal),
                  ),
                  title: Text(
                    ex.getBasicInfo(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(ex.getDetailInfo()),
                      const SizedBox(height: 4),
                      Row(
                        children: List.generate(
                          5,
                          (starIdx) => Icon(
                            starIdx < ex.rating
                                ? Icons.star
                                : Icons.star_border,
                            size: 15,
                            color: Colors.amber,
                          ),
                        ),
                      ),
                    ],
                  ),
                  trailing: ElevatedButton(
                    onPressed: () => _showExerciseDetailModal(ex),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal.shade50,
                      elevation: 0,
                    ),
                    child: const Text(
                      'Chi tiết',
                      style: TextStyle(
                        color: Colors.teal,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}

class ReviewWidget extends StatefulWidget {
  final int initialRating;
  final ValueChanged<int> onRatingChanged;

  const ReviewWidget({
    super.key,
    required this.initialRating,
    required this.onRatingChanged,
  });

  @override
  State<ReviewWidget> createState() => _ReviewWidgetState();
}

class _ReviewWidgetState extends State<ReviewWidget> {
  late int _rating;

  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return GestureDetector(
              onTap: () {
                setState(() => _rating = index + 1);
                widget.onRatingChanged(_rating);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Icon(
                  index < _rating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 36,
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 6),
        Text(
          'Mức độ hài lòng: $_rating / 5 sao',
          style: const TextStyle(
            color: Colors.teal,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}