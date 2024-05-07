import 'package:flutter/material.dart';
import 'package:habit_tracker_app/components/drawer.dart';
import 'package:habit_tracker_app/components/my_habit_tile.dart';
import 'package:habit_tracker_app/components/my_heatmap.dart';
import 'package:habit_tracker_app/database/habit_database.dart';
import 'package:habit_tracker_app/models/habit.dart';
import 'package:habit_tracker_app/util/habit_utility.dart';
import 'package:provider/provider.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  void initState() {
    Provider.of<HabitDatabase>(context, listen: false).readHabits();
    super.initState();
  }

  final TextEditingController textController = TextEditingController();
  //create new habit
  void createNewHabit() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Center(
            child: Text(
          "create a new habit",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        )),
        content: TextField(
          controller: textController,
        ),
        actions: [
          //save button
          MaterialButton(
            onPressed: () {
              //get the text string
              String newHabitName = textController.text;
              //save to db
              context.read<HabitDatabase>().addHabits(newHabitName);
              //pop dialog
              Navigator.pop(context);
              //clear controller

              textController.clear();
            },
            child: const Text("save"),
          ),
          MaterialButton(
            onPressed: () {
              //pop dialog
              Navigator.pop(context);
              //clear controller

              textController.clear();
            },
            child: const Text("cancel"),
          )
          //cancel button
        ],
      ),
    );
  }

//toggle habit on or off
  void checkHabitOnOff(bool? value, Habit habit) {
    if (value != null) {
      context.read<HabitDatabase>().updatehabitCompletion(habit.id, value);
    }
  }

//Edit habit name
  void editHabitBox(Habit habit) {
    //first we set the controller text to the habit name
    textController.text = habit.name;

    //showdialogu
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(controller: textController),
        title: const Center(
            child: Text(
          "Edit habit name",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        )),
        actions: [
          MaterialButton(
              onPressed: () {
                //get the text string
                String newHabitName = textController.text;
                //save to db
                context
                    .read<HabitDatabase>()
                    .updateHabitName(habit.id, newHabitName);
                //pop dialog
                Navigator.pop(context);
                //clear controller

                textController.clear();
              },
              child: const Text("save")),
          MaterialButton(
            onPressed: () {
              //clear textcontroller
              textController.clear();
              //pop Navigator
              Navigator.pop(context);
            },
            child: const Text("cancel"),
          )
        ],
      ),
    );
  }

  void deleteHabitBox(Habit habit) {
    //first we set the controller text to the habit name
    textController.text = habit.name;

    //showdialogu
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(habit.name),
        title: const Center(
            child: Text(
          "Are you sure you want to delete?",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        )),
        actions: [
          MaterialButton(
              onPressed: () {
                //save to db
                context.read<HabitDatabase>().deleteHabit(habit.id);
                //pop dialog
                Navigator.pop(context);
              },
              color: Colors.red,
              child: const Text(
                "delete",
                style: TextStyle(color: Colors.white),
              )),
          MaterialButton(
            onPressed: () {
              //clear textcontroller
              textController.clear();
              //pop Navigator
              Navigator.pop(context);
            },
            child: const Text("cancel"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: const MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewHabit,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
      body: ListView(
        children: [
          //HEATMAP
          _buildHeatMap(),
          //HABITS
          _buildHabitList()
        ],
      ),
    );
  }

  Widget _buildHabitList() {
    //Habits db
    final habitsDatabase = context.watch<HabitDatabase>();

    //current habit list
    List<Habit> currentHabits = habitsDatabase.currentHabits;

    return ListView.builder(
        itemCount: currentHabits.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          //get individual habit
          final habit = currentHabits[index];

          //check if habit is completed
          bool isCompletedToday = isHabitCompletedToday(habit.completedDays);
          //return habit tile
          return MyHabitTile(
            isCompleted: isCompletedToday,
            text: habit.name,
            onChanged: (value) => checkHabitOnOff(value, habit),
            editHabit: (BuildContext context) => editHabitBox(habit),
            deleteHabit: (BuildContext context) => deleteHabitBox(habit),
          );
        });
  }

  Widget _buildHeatMap() {
    //get database
    final habitsDatabase = context.watch<HabitDatabase>();

    //get current habits

    List<Habit> currentHabits = habitsDatabase.currentHabits;
    return FutureBuilder<DateTime?>(
      future: habitsDatabase.getFirstLaunchDate(),
      builder: (context, snapshot) {
        //once the data is available -> build heatmap

        if (snapshot.hasData) {
          return MyHeatmap(
              startDate: snapshot.data!,
              datasets: prepHeatmapDatasets(currentHabits));
        } else {
          return Container();
        }
      },
    );
  }
}
