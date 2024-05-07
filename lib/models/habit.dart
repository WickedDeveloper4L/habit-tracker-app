import 'package:isar/isar.dart';

//run: dart run build_runner build
part 'habit.g.dart';

@collection
class Habit {
  //HabitId
  Id id = Isar.autoIncrement;

//Habit name
  late String name;

//Completed days
  List<DateTime> completedDays = [
    //DateTime(Year, month, day)
  ];
}
