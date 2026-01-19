import 'package:bene/components/exercise_tile.dart';
import 'package:bene/data/workout.data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkoutPage extends StatefulWidget {
  final String WorkoutName;
  const WorkoutPage({super.key, required this.WorkoutName});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {

  void onCheckBoxChanged(String workoutName, String exerciseName) {
    Provider.of<WorkoutData>(context, listen: false)
    .checkOffExercise(workoutName, exerciseName);  
  }

  final exerciseNameController = TextEditingController();
  final weightController = TextEditingController();
  final repsController = TextEditingController();
  final setsController = TextEditingController();

//Criar novo exercício
void createNewExercise() {
  showDialog(context: context, builder: (context) => AlertDialog(
    title: Text('Adicionar novo exercício'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
      TextField(
        controller: exerciseNameController,
      ),
      TextField(
        controller: weightController,
      ),
      TextField(
        controller: repsController,
      ),
      TextField(
        controller: setsController,
      ),
    ],),
    actions: [
      MaterialButton(
        onPressed: save,
        child: Text("Salvar"),  
      ),

      MaterialButton(
        onPressed: cancel,
        child: Text("Cancelar"),  
      ),
    ],
  ));
}

 //Salvar criação de exercício
  void save() { 
    String newExerciseName = exerciseNameController.text;
    String weight = weightController.text;
    String reps = repsController.text;
    String sets = setsController.text;
    Provider.of<WorkoutData>(context, listen: false).addExercise(
      widget.WorkoutName, 
      newExerciseName, 
      weight, 
      reps, 
      sets
    );

    Navigator.pop(context);
    clear();
  }


  //Cancelar criação exercício
  void cancel() {

    Navigator.pop(context);
    clear();
  }

  //Limpar controllers
  void clear() {
    exerciseNameController.clear();
    weightController.clear();
    repsController.clear();
    setsController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
        builder: (context, value, child) => Scaffold(
        appBar: AppBar(title: Text(widget.WorkoutName),),
        floatingActionButton: FloatingActionButton(
          onPressed: createNewExercise,
          child: Icon(Icons.add),
        ),
        body: ListView.builder(
          itemCount: value.numberOfxercisesInWorkout(widget.WorkoutName),
          itemBuilder: (context, index) => ExerciseTile(
            exerciseName: value.getRelevantWorkout(widget.WorkoutName).exercises[index].name, 
            weight: value.getRelevantWorkout(widget.WorkoutName).exercises[index].weight, 
            reps: value.getRelevantWorkout(widget.WorkoutName).exercises[index].reps, 
            sets: value.getRelevantWorkout(widget.WorkoutName).exercises[index].sets, 
            isCompleted: value.getRelevantWorkout(widget.WorkoutName).exercises[index].isCompleted, 
            onCheckBoxChanged: (val) => onCheckBoxChanged(widget.WorkoutName, value.getRelevantWorkout(widget.WorkoutName).exercises[index].name),
          )
        ),
      ),
    );
  } 
} 