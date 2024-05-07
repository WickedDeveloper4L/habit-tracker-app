import 'package:flutter/material.dart';
import 'package:habit_tracker_app/models/app_settings.dart';
import 'package:habit_tracker_app/models/habit.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class HabitDatabase extends ChangeNotifier {
  static late Isar isar;

  /*    
    S E T U P
  */

  //INITIALIAZE DATABASE
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar =
        await Isar.open([HabitSchema, AppSettingsSchema], directory: dir.path);
  }
  //Save first date of app startup(for heatmap)

  Future<void> saveFirstLaunchDate() async {
    final existingSettings = await isar.appSettings.where().findFirst();
    if (existingSettings == null) {
      final settings = AppSettings()..firstLaunchDate = DateTime.now();
      await isar.writeTxn(() => isar.appSettings.put(settings));
    }
  }

  //Get first date of app startup (for heatmap)
  Future<DateTime?> getFirstLaunchDate() async {
    final settings = await isar.appSettings.where().findFirst();
    return settings?.firstLaunchDate;
  }
  /*
  CRUD OPERATIONS
  */

  //List of habits
  final List<Habit> currentHabits = [];

  //CREATE - add new habit
  Future<void> addHabits(String habitName) async {
    //create New habit
    final newhabit = Habit()..name = habitName;

    //save to db
    await isar.writeTxn(() => isar.habits.put(newhabit));

    //re-read the db
    readHabits();
  }

  //READ - read saved habits from db
  Future<void> readHabits() async {
    //fetch all habits from db
    List<Habit> fetchedHabits = await isar.habits.where().findAll();

    //give to current habits
    currentHabits.clear();
    currentHabits.addAll(fetchedHabits);

    //update Ui
    notifyListeners();
  }

  //UPDATE - check habit on and off
  Future<void> updatehabitCompletion(int id, bool isCompleted) async {
    //find the specific habit
    final habit = await isar.habits.get(id);

    //update completion status
    if (habit != null) {
      await isar.writeTxn(() async {
        //if habit is completed -> add the current date to the list
        if (isCompleted && !habit.completedDays.contains(DateTime.now())) {
          //today
          final today = DateTime.now();

          //add the current date if its not already in the list

          habit.completedDays.add(DateTime(today.year, today.month, today.day));
        }
        //if habit is NOT completd -> remove the current date from the list
        else {
          //remove the current date if the habit is marked as completed
          habit.completedDays.removeWhere((date) =>
              date.year == DateTime.now().year &&
              date.month == DateTime.now().month &&
              date.day == DateTime.now().day);
        }
        //save the updated habits to  the db
        await isar.habits.put(habit);
      });
    }
    //re-read habits
    readHabits();
  }

  //UPDATE edit habit name
  Future<void> updateHabitName(int id, String newName) async {
    //find specific habit in db
    final habit = await isar.habits.get(id);

    //update habit name
    if (habit != null) {
      await isar.writeTxn(() async {
        habit.name = newName;

        //save updated habit to db
        await isar.habits.put(habit);
      });
    }
    //re-read from db

    readHabits();
  }

  //DELETE - delete habit
  Future<void> deleteHabit(int id) async {
    //get specific habit
    final habit = await isar.habits.get(id);

    //delete habit
    if (habit != null) {
      await isar.writeTxn(() async {
        await isar.habits.delete(id);
      });
    }
    //re-read db
    readHabits();
  }
}
