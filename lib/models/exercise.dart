// File: lib/models/exercise.dart
import 'base_entity.dart';

class Exercise extends BaseEntity<String> {
  final int durationInMinutes;
  final double caloriesPerMinute;
  final String category;
  final String setsAndReps;
  int rating;
  bool isCompleted;

  Exercise({
    required super.id,
    String? name,
    String? exerciseName,
    super.description = 'Bài tập thể lực tiêu chuẩn',
    required this.durationInMinutes,
    required this.caloriesPerMinute,
    this.category = 'Toàn thân',
    this.setsAndReps = '3 hiệp x 12 lần',
    this.rating = 5,
    this.isCompleted = false,
  }) : super(name: name ?? exerciseName ?? 'Bài tập');

  String get exerciseName => name;

  double getBurnedCalories() {
    return durationInMinutes * caloriesPerMinute;
  }

  @override
  String getDetailInfo() {
    return '$category • $setsAndReps • ${durationInMinutes}p (${getBurnedCalories().toStringAsFixed(0)} kcal)';
  }

  Exercise copyWith({
    String? id,
    String? name,
    String? description,
    int? durationInMinutes,
    double? caloriesPerMinute,
    String? category,
    String? setsAndReps,
    int? rating,
    bool? isCompleted,
  }) {
    return Exercise(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      durationInMinutes: durationInMinutes ?? this.durationInMinutes,
      caloriesPerMinute: caloriesPerMinute ?? this.caloriesPerMinute,
      category: category ?? this.category,
      setsAndReps: setsAndReps ?? this.setsAndReps,
      rating: rating ?? this.rating,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'durationInMinutes': durationInMinutes,
      'caloriesPerMinute': caloriesPerMinute,
      'category': category,
      'setsAndReps': setsAndReps,
      'rating': rating,
      'isCompleted': isCompleted,
    };
  }

  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      id: map['id']?.toString() ?? 'EX01',
      name: map['name']?.toString() ?? 'Bài tập',
      description: map['description']?.toString() ?? 'Bài tập thể lực',
      durationInMinutes: (map['durationInMinutes'] as num?)?.toInt() ?? 15,
      caloriesPerMinute: (map['caloriesPerMinute'] as num?)?.toDouble() ?? 8.0,
      category: map['category']?.toString() ?? 'Toàn thân',
      setsAndReps: map['setsAndReps']?.toString() ?? '3 hiệp x 12 lần',
      rating: (map['rating'] as num?)?.toInt() ?? 5,
      isCompleted: map['isCompleted'] == true,
    );
  }
}