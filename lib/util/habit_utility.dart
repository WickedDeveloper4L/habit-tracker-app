//given a habit list of completed days
//check if the habit is completed today

import 'package:habit_tracker_app/models/habit.dart';

bool isHabitCompletedToday(List<DateTime> completedDays) {
  final today = DateTime.now();
  return completedDays.any((date) =>
      date.year == today.year &&
      date.month == today.month &&
      date.day == today.day);
}

//Prepare heatmap dataset

Map<DateTime, int> prepHeatmapDatasets(List<Habit> habits) {
  Map<DateTime, int> datasets = {};

  for (var habit in habits) {
    for (var date in habit.completedDays) {
      //normalize date to avoid date mismatch
      final normalizedDate = DateTime(date.year, date.month, date.day);

      //if the date already exists in the dataset, increment its count
      if (datasets.containsKey(normalizedDate)) {
        datasets[normalizedDate] = datasets[normalizedDate]! + 1;
      } else {
        //else initialize it with a count of 1

        datasets[normalizedDate] = 1;
      }
    }
  }

  return datasets;
}
