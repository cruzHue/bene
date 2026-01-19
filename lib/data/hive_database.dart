import 'package:bene/datetime/date_time.dart';
import 'package:bene/models/exercise.dart';
import 'package:bene/models/workout.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveDatabase {
  final _myBox = Hive.box('Banco de Dados 1');

  // Checar se há dados anteriores
  bool previousDataExists() {
    if (_myBox.isEmpty) {
      _myBox.put("DATA_ATUAL", todaysDateDDMMYY());
      return false;
    } else {
      return true;
    }
  }

  // Data inicial
  String getStartDate() {
    return _myBox.get("DATA_ATUAL");
  }

  // Salvar dados
  void saveToDatabase(List<Workout> workouts) {
    final workoutList = convertObjectToWorkoutList(workouts);
    final exerciseList = convertObjectToExerciseList(workouts);

    if (exerciseCompleted(workouts)) {
      _myBox.put("COMPLETION_STATUS_${todaysDateDDMMYY()}", 1);
    } else {
      _myBox.put("COMPLETION_STATUS_${todaysDateDDMMYY()}", 0);
    }

    _myBox.put("WORKOUTS", workoutList);
    _myBox.put("EXERCISES", exerciseList);
  }

  // Ler dados
  List<Workout> readFromDatabase() {
    List<Workout> mySavedWorkouts = [];

    // Cast seguro
    List<String> workoutNames =
        (_myBox.get("WORKOUTS") as List).map((e) => e.toString()).toList();

    final rawExercises = _myBox.get("EXERCISES") as List;

    List<List<List<String>>> exerciseDetails =
        rawExercises.map<List<List<String>>>((workout) {
      return (workout as List).map<List<String>>((exercise) {
        return (exercise as List).map<String>((item) {
          return item.toString();
        }).toList();
      }).toList();
    }).toList();

    for (int i = 0; i < workoutNames.length; i++) {
      List<Exercise> exercisesInEachWorkout = [];

      for (int j = 0; j < exerciseDetails[i].length; j++) {
        exercisesInEachWorkout.add(
          Exercise(
            name: exerciseDetails[i][j][0],
            weight: exerciseDetails[i][j][1],
            reps: exerciseDetails[i][j][2],
            sets: exerciseDetails[i][j][3],
            isCompleted: exerciseDetails[i][j][4] == "true",
          ),
        );
      }

      mySavedWorkouts.add(
        Workout(
          name: workoutNames[i],
          exercises: exercisesInEachWorkout,
        ),
      );
    }

    return mySavedWorkouts;
  }

  // Ver se há exercício completo
  bool exerciseCompleted(List<Workout> workouts) {
    for (var workout in workouts) {
      for (var exercise in workout.exercises) {
        if (exercise.isCompleted) {
          return true;
        }
      }
    }
    return false;
  }

  // Ler status do dia
  int getCompletionStatus(String ddmmyy) {
    return _myBox.get("COMPLETION_STATUS_$ddmmyy") ?? 0;
  }
}

// Converter treinos
List<String> convertObjectToWorkoutList(List<Workout> workouts) {
  List<String> workoutList = [];

  for (var workout in workouts) {
    workoutList.add(workout.name);
  }

  return workoutList;
}

// Converter exercícios
List<List<List<String>>> convertObjectToExerciseList(List<Workout> workouts) {
  List<List<List<String>>> exerciseList = [];

  for (var workout in workouts) {
    List<List<String>> individualWorkout = [];

    for (var exercise in workout.exercises) {
      individualWorkout.add([
        exercise.name,
        exercise.weight,
        exercise.reps,
        exercise.sets,
        exercise.isCompleted.toString(),
      ]);
    }

    exerciseList.add(individualWorkout);
  }

  return exerciseList;
}
