import 'package:bene/Pages/workout_page.dart';
import 'package:bene/components/heat_map.dart';
import 'package:bene/data/workout.data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class HomePage extends StatefulWidget {
  const HomePage ({super.key});

  @override 
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override 
  void initState() {
    super.initState();
    Provider.of<WorkoutData>(context, listen:  false).initializeWorkoutList();
  }

  //Controle de texto
  final newWorkoutNameController = TextEditingController();

  //Criar novo treino
  void createNewWorkout() {
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: Text('Criar novo treino'),
        content: TextField(
          controller: newWorkoutNameController,
        ),
        actions: [
          //salvar
          MaterialButton(
            onPressed: save,
            child: Text('Salvar'),
          ),

          //cancelar
          MaterialButton(
            onPressed: cancel,
            child: Text('Cancelar'),
          ),
        ],
      )
    );
  }

  //Vai para a página de treinos

  void goToWorkoutPage(String WorkoutName) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => WorkoutPage(WorkoutName: WorkoutName,) ,));
  } 

  //Salvar criação de treino
  void save() { 
    String newWorkoutName = newWorkoutNameController.text;
    Provider.of<WorkoutData>(context, listen: false).addWorkout(newWorkoutName);

    Navigator.pop(context);
    clear();
  }


  //Cancelar criação de treino
  void cancel() {

    Navigator.pop(context);
    clear();
  }

  //Limpar controllers
  void clear() {
    newWorkoutNameController.clear();
  }

  @override 
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          title: const Text('Bene'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed:createNewWorkout,
          child: const Icon(Icons.add), 
          ),
        body: ListView(
          children: [
            MyHeatMap(datasets: value.heatMapDataSet, startDateDDMMYY: value.getStartDate()),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: value.getWorkoutList().length,
              itemBuilder: (context, index) => ListTile(
                title: Text(value.getWorkoutList()[index].name),
                trailing: IconButton(
                  icon: Icon(Icons.arrow_forward_ios),
                  onPressed: () => goToWorkoutPage(value.getWorkoutList()[index].name),  
                ),
              ) 
            ),
          ],
        ),
      ),
    );
  }
}