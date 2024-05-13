import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:opt120/models/activity_model.dart';
import 'package:opt120/services/activity_api.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  List<ActivityModel> activities = [];
  final _titleTextController = TextEditingController();
  final _descriptionTextController = TextEditingController();
  final _dateController = TextEditingController();

  ActivityModel? _activity;
  DateTime? _dateTime;

  @override
  void initState() {
    super.initState();
    fetchActivities();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> fetchActivities() async {
    try {
      final activitiesList = await ActivityApi().getActivities();
      setState(() {
        activities = activitiesList;
      });
    } catch (e) {
      print('Failed to fetch activities: $e');
    }
  }

  Future<void> getActivity(id) async {
    try {
      final activity = await ActivityApi().getActivity(id);
      _activity = activity;
      _activity?.id = activity.id;
      _titleTextController.text = _activity!.title;
      _descriptionTextController.text = _activity!.description;
      _dateController.text = DateFormat('dd-MM-yyyy').format(_activity!.date);
    } catch (e) {
      print('Failed to get activity: $e');
    }
  }

  Future<void> update(id) async {
    var tempMap = {
      "id": id,
      "title": _titleTextController.text,
      "description": _descriptionTextController.text,
      "delivery_date": _dateTime
    };
    print("UPDATE");
    print(tempMap);
    ActivityModel activity = ActivityModel.fromMap(tempMap);

    try {
      await ActivityApi().update(activity);

      // _titleTextController.clear();
      // _descriptionTextController.clear();
      // _dateController.clear();
    } catch (e) {
      print('Erro ao editar atividade: $e');
      _showSnackBar(
          "Erro ao editar atividade. Por favor, tente novamente mais tarde.");
    }
  }

  Future<void> delete(id) async {
    try {
      await ActivityApi().delete(id);
      _showSnackBar("Atividade deletada com sucesso!");
    } catch (e) {
      print('Failed to delete activity: $e');
      _showSnackBar("Erro ao deletar atividade!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Atividades", style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: Colors.white),
            tooltip: 'Adicionar atividade',
            onPressed: () async {
              await Navigator.of(context).pushNamed('/activityRegister').then(
                (_) {
                  initState();
                },
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: activities.length,
        itemBuilder: (context, index) {
          final activity = activities[index];
          return ListTile(
            title: Text(activity.title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(activity.description),
                Text(DateFormat('dd-MM-yyyy').format(activity.date)),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 40,
                  child: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () async {
                      await getActivity(activity.id);
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Form(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      "Editar atividade",
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 28,
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
                                          border: OutlineInputBorder(),
                                          labelText: 'Título'),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: TextFormField(
                                      controller: _descriptionTextController,
                                      decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: 'Descrição'),
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
                                        DateTime? pickeddate =
                                            await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime(2101),
                                          initialDatePickerMode:
                                              DatePickerMode.year,
                                        );

                                        if (pickeddate != null) {
                                          setState(
                                            () {
                                              _dateTime = pickeddate;
                                              _dateController.text =
                                                  DateFormat('yyyy-MM-dd')
                                                      .format(pickeddate);
                                            },
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, 'Cancelar'),
                                child: const Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await update(activity.id);
                                  Navigator.pop(context, 'Editar');
                                  fetchActivities();
                                },
                                child: const Text('Editar'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
                SizedBox(
                  width: 40,
                  child: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Deletar Atividade'),
                            content: const Text(
                                'Deseja realmente deletar está atividade?'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, 'Cancelar'),
                                child: const Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await delete(activity.id);
                                  Navigator.pop(context, 'OK');
                                  fetchActivities();
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
