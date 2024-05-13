import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/activity_model.dart';
import '../services/activity_api.dart';

class ActivityRegisterScreen extends StatelessWidget {
  const ActivityRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "OPT120",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: false,
      ),
      body: const Center(
        child: SizedBox(
          width: 400,
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: ActivityForm(),
            ),
          ),
        ),
      ),
    );
  }
}

class ActivityForm extends StatefulWidget {
  const ActivityForm({super.key});

  @override
  State<ActivityForm> createState() => _ActivityFormState();
}

class _ActivityFormState extends State<ActivityForm> {
  final _titleTextController = TextEditingController();
  final _descriptionTextController = TextEditingController();
  final _dateController = TextEditingController();

  ActivityModel? _activity;

  String? function;
  DateTime? _dateTime;
  double _formProgress = 0;

  void _updateFormProgress() {
    var progress = 0.0;
    final controllers = [
      _titleTextController,
      _descriptionTextController,
      _dateController
    ];

    for (final controller in controllers) {
      if (controller.value.text.isNotEmpty) {
        progress += 1 / controllers.length;
      }
    }

    setState(() {
      _formProgress = progress;
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> create() async {
    var tempMap = {
      "title": _titleTextController.text,
      "description": _descriptionTextController.text,
      "delivery_date": _dateTime
    };

    ActivityModel activity = ActivityModel.fromMap(tempMap);

    try {
      String message = await ActivityApi().create(activity);
      Navigator.of(context).pushReplacementNamed('/activityList');
      _titleTextController.clear();
      _descriptionTextController.clear();
      _dateController.clear();
      _showSnackBar(message);
    } catch (e) {
      print(e);
      Navigator.of(context).pushReplacementNamed('/activityRegister');
      _showSnackBar(e.toString());
    }
  }

  Future<void> _update() async {
    var tempMap = {
      "title": _titleTextController.text,
      "description": _descriptionTextController.text,
      "delivery_date": _dateTime
    };

    ActivityModel activity = ActivityModel.fromMap(tempMap);

    try {
      await ActivityApi().update(activity);
      _titleTextController.clear();
      _descriptionTextController.clear();
      _dateController.clear();
    } catch (e) {
      print('Erro ao editar atividade: $e');
      _showSnackBar(
          "Erro ao editar atividade. Por favor, tente novamente mais tarde.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      onChanged: _updateFormProgress,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LinearProgressIndicator(value: _formProgress),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              "Cadastro de atividade",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              onChanged: (value) {
                _activity?.description = value;
              },
              controller: _titleTextController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Título'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _descriptionTextController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Descrição'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _dateController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
                hintText: 'Data',
              ),
              onTap: () async {
                DateTime? pickeddate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                  initialDatePickerMode: DatePickerMode.year,
                );

                if (pickeddate != null) {
                  setState(
                    () {
                      _dateTime = pickeddate;
                      _dateController.text =
                          DateFormat('yyyy-MM-dd').format(pickeddate);
                    },
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
              height: 50,
              width: 150,
              child: TextButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.resolveWith(
                    (states) {
                      return states.contains(MaterialState.disabled)
                          ? null
                          : Colors.white;
                    },
                  ),
                  backgroundColor: MaterialStateProperty.resolveWith(
                    (states) {
                      return states.contains(MaterialState.disabled)
                          ? null
                          : Theme.of(context).primaryColor;
                    },
                  ),
                ),
                onPressed: _formProgress == 1
                    ? () {
                        create();
                        Navigator.pop(context, 'Criar');
                      }
                    : null,
                child: Text(
                  "Cadastrar",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
