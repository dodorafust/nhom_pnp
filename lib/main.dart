import 'user_profile.dart';
import 'exercise.dart';
import 'workout_session.dart';

void main() {
  UserProfile user = UserProfile(name: "Phát", weight: 70, height: 1.75);
  print("--- KẾT QUẢ CỦA PHÁT ---");
  print("Người dùng: ${user.name}");
  print(user.calculateBMI());

  Exercise pushUp = Exercise(exerciseName: "Hít đất", durationInMinutes: 15, caloriesPerMinute: 8.5);
  Exercise running = Exercise(exerciseName: "Chạy bộ", durationInMinutes: 30, caloriesPerMinute: 10.0);
  print("\n--- KẾT QUẢ CỦA NAM ---");
  print("Bài tập: \({pushUp.exerciseName} - Tiêu hao:\){pushUp.getBurnedCalories()} calo");

  WorkoutSession session = WorkoutSession(sessionId: "SS001", date: DateTime.now());
  session.addExercise(pushUp);
  session.addExercise(running);
  print("\n--- KẾT QUẢ CỦA PHONG ---");
  print("Tổng calo buổi tập (Hít đất + Chạy bộ): ${session.calculateTotalCalories()} calo");
}