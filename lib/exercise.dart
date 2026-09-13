class Exercise {
  String exerciseName;
  int durationInMinutes;
  double caloriesPerMinute;

  Exercise({
    required this.exerciseName,
    required this.durationInMinutes,
    required this.caloriesPerMinute,
  });

  double getBurnedCalories() {
    return durationInMinutes * caloriesPerMinute;
  }
}