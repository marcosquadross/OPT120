import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../services/user_activity_api.dart';
import '../services/user_api.dart';
import '../models/user_model.dart';
import '../services/activity_api.dart';
import '../models/activity_model.dart';
import '../models/user_activity_model.dart';

class UserActivityRegisterScreen extends StatelessWidget {
  const UserActivityRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("OPT120"),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: false,
        actions: [
          // Image.asset('assets/icone2.png'),
        ],
      ),
      body: const Center(
        child: SizedBox(
          width: 400,
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: UserActivityForm(),
            ),
          ),
        ),
      ),
    );
  }
}

const List<String> list = <String>['One', 'Two', 'Three', 'Four'];

class UserActivityForm extends StatefulWidget {
  const UserActivityForm({super.key});

  @override
  State<UserActivityForm> createState() => _UserActivityFormState();
}

class _UserActivityFormState extends State<UserActivityForm> {
  final _dateController = TextEditingController();
  final _scoreController = TextEditingController();

  int? _userId;
  int? _activityId;
  DateTime? _deliveryDateTime;

  double _formProgress = 0;

  @override
  void initState() {
    super.initState();
    fetchUsers();
    fetchActivities();
  }

  void _updateFormProgress() {
    var progress = 0.0;
    final activity = [_userId, _activityId, _dateController, _scoreController];

    for (final input in activity) {
      if (input is TextEditingController) {
        if (input.text.isNotEmpty) {
          progress += 1 / activity.length;
        }
      } else if (input != null && input.toString().isNotEmpty) {
        progress += 1 / activity.length;
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

  List<UserModel> users = [];
  List<ActivityModel> activities = [];

  Future<void> fetchUsers() async {
    try {
      final usersList = await UserApi().getUsers();
      setState(() {
        users = usersList;
      });
    } catch (e) {
      print('Failed to fetch users: $e');
    }
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

  Future<void> create() async {
    var userActivityModel = UserActivityModel(
        userId: _userId!,
        activityId: _activityId!,
        deliveryDate: _deliveryDateTime!,
        score: double.parse(_scoreController.text));

    try {
      String message = await UserActivityApi().create(userActivityModel);
      Navigator.of(context).pushReplacementNamed('/userActivityList');
      _dateController.clear();
      _scoreController.clear();
      _showSnackBar(message);
    } catch (e) {
      Navigator.of(context).pushReplacementNamed('/userActivityRegister');
      _showSnackBar(e.toString());
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      onChanged: _updateFormProgress,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LinearProgressIndicator(value: _formProgress),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              "Atribuir atividade",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: DropdownButtonFormField<int>(
              value: _userId,
              items: users.map((UserModel user) {
                return DropdownMenuItem<int>(
                    value: user.id, child: Text(user.name));
              }).toList(),
              onChanged: (int? value) {
                setState(() {
                  _userId = value!;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Selecione um usuário',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: DropdownButtonFormField<int>(
              value: _activityId,
              items: activities.map((ActivityModel activity) {
                return DropdownMenuItem<int>(
                    value: activity.id, child: Text(activity.title));
              }).toList(),
              onChanged: (int? value) {
                setState(() {
                  _activityId = value!;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Selecione uma atividade',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _dateController,
              decoration: const InputDecoration(
                suffixIcon: Icon(Icons.calendar_today),
                border: OutlineInputBorder(),
                labelText: 'Entrega',
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
                  setState(() {
                    _deliveryDateTime = pickeddate;
                    _dateController.text =
                        DateFormat('yyyy-MM-dd').format(pickeddate);
                  });
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              controller: _scoreController,
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(r'^\d*\.?\d{0,1}'),
                ),
              ],
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Nota',
              ),
              validator: (value) {
                if (double.tryParse(value!) == null) {
                  return 'Por favor, insira um valor numérico válido';
                }
                final double score = double.parse(value);
                if (score < 0 || score > 10) {
                  return 'A nota deve estar entre 0 e 10';
                }
                return null;
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
                  foregroundColor: MaterialStateProperty.resolveWith((states) {
                    return states.contains(MaterialState.disabled)
                        ? null
                        : Colors.white;
                  }),
                  backgroundColor: MaterialStateProperty.resolveWith((states) {
                    return states.contains(MaterialState.disabled)
                        ? null
                        : Theme.of(context).primaryColor;
                  }),
                ),
                onPressed: _formProgress == 1
                    ? () {
                        if (_formKey.currentState!.validate()) {
                          create();
                          Navigator.pop(context, "Atribuir");
                        }
                      }
                    : null,
                child: const Text('Atribuir', style: TextStyle(fontSize: 20)),
              ),
            ),
          )
        ],
      ),
    );
  }
}
