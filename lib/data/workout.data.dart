import 'package:bene/data/hive_database.dart';
import 'package:bene/datetime/date_time.dart';
import 'package:bene/models/exercise.dart';
import 'package:flutter/material.dart';
import '../models/workout.dart';


class WorkoutData extends ChangeNotifier {
  final db = HiveDatabase();

  List<Workout> workoutList = [
    Workout (
      name: "Superior",
      exercises: [
        Exercise(
          name: "Scott", 
          weight: "10", 
          reps: "10", 
          sets: "3"
        ),
      ], 
    )
  ];

  void initializeWorkoutList() {
    if(db.previousDataExists()) {
      workoutList = db.readFromDatabase();
    } else {
      db.saveToDatabase(workoutList);
    }

    loadHeatMap();
  }

  //chamar lista de treinos
  List<Workout> getWorkoutList() {
    return workoutList;
  }

  //chamar a duração de um treino qualquer
  int numberOfxercisesInWorkout(String workoutName) {
    Workout relevantWorkout = getRelevantWorkout(workoutName);
    return relevantWorkout.exercises.length;
  }


  //adicionar lista de treinos
  void addWorkout(String name) {
    workoutList.add(Workout(name: name, exercises: [] ));

    notifyListeners();

    db.saveToDatabase(workoutList);

  }

  //adicionar um exercício em um treino
  void addExercise(
    String workoutName, 
    String exerciseName, 
    String weight, 
    String reps, 
    String sets) {
      
      Workout relevantWorkout = getRelevantWorkout(workoutName); 
      relevantWorkout.exercises.add(Exercise(
        name: exerciseName, 
        weight: weight, 
        reps: reps, 
        sets: sets,
      ));
      notifyListeners();
      db.saveToDatabase(workoutList);
    }

  //verificar exercício
  void checkOffExercise(String workoutName, String exerciseName) {
    //encontrar o treino relevante e o exercício relevante dentro desse treino
    Exercise relevantExercise = getRelevantExercise(workoutName, exerciseName);

    relevantExercise.isCompleted = !relevantExercise.isCompleted;

    notifyListeners();
    db.saveToDatabase(workoutList);

    loadHeatMap();
  }
    //achar o treino relevante
      Workout getRelevantWorkout(String workoutName) { 
        Workout relevantWorkout =
          workoutList.firstWhere((workout) => workout.name == workoutName);
        return relevantWorkout;
      }

    //achar o exercício relevante
      Exercise getRelevantExercise(String workoutName, String exerciseName) {
        Workout relevantWorkout = getRelevantWorkout(workoutName);
        Exercise relevantExercise = relevantWorkout.exercises.firstWhere((exercise) => exercise.name == exerciseName);
        return relevantExercise;
      }
  
  String getStartDate() {
    return db.getStartDate();
  }

  Map<DateTime, int> heatMapDataSet = {};

  void loadHeatMap() {
    DateTime startDate = createDateTimeObject(getStartDate());
    int daysInBetween = DateTime.now().difference(startDate).inDays;

    for (int i=0; i< daysInBetween+1; i++) {
      String ddmmyy = convertDateTimeToDDMMYY(startDate.add(Duration(days: i)));

      int completionStatus = db.getCompletionStatus(ddmmyy);

      int day = startDate.add(Duration(days: i)).day;
      int month = startDate.add(Duration(days: i)).month;
      int year = startDate.add(Duration(days: i)).year;

      final percentForEachDay = <DateTime, int> {
        DateTime(day, month, year) : completionStatus
      };

      heatMapDataSet.addEntries(percentForEachDay.entries);
    }
  }

}