import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../models/user_model.dart';
import '../models/user_activity_model.dart';
import '../services/user_api.dart';
import '../services/user_activity_api.dart';
import '../services/activity_api.dart';
import '../models/activity_model.dart';

class UserActivityScreen extends StatefulWidget {
  const UserActivityScreen({super.key});

  @override
  State<UserActivityScreen> createState() => _UserActivityScreenState();
}

class _UserActivityScreenState extends State<UserActivityScreen> {
  List<UserActivityModel> userActivities = [];
  List<ActivityModel> activities = [];
  List<UserModel> users = [];

  final _scoreController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserActivities();
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _fetchUserActivities() async {
    try {
      final activities = await UserActivityApi().getUserActivities();
      setState(() {
        userActivities = activities;
      });
    } catch (e) {
      showSnackBar('Failed to fetch activities: $e');
    }
  }

  Future<UserModel> _getUser(id) async {
    try {
      final user = await UserApi().getUser(id);
      return user;
    } catch (e) {
      rethrow;
    }
  }

  Future<ActivityModel> _getActivity(id) async {
    try {
      final activity = await ActivityApi().getActivity(id);
      return activity;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _updateScore(userId, activityId, score) async {
    try {
      await UserActivityApi().updateScore(userId, activityId, score);
      showSnackBar('Nota atualizada!');
    } catch (e) {
      showSnackBar('Erro ao atualizar atividade!');
      rethrow;
    }
  }

  Future<void> _delete(userId, activityId) async {
    try {
      await UserActivityApi().delete(userId, activityId);
      showSnackBar('Atividade deletada com sucesso!');
    } catch (e) {
      showSnackBar('Erro ao deletar atividade!');
      rethrow;
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Atribuir atividade',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: Colors.white),
            tooltip: 'Atribuir atividade',
            onPressed: () async {
              await Navigator.of(context).pushNamed(
                '/userActivityRegister',
              );
              // fetchActivities();
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: userActivities.length,
        itemBuilder: (context, index) {
          final userActivity = userActivities[index];
          return ListTile(
            title: FutureBuilder<ActivityModel>(
              future: _getActivity(userActivity.activityId),
              builder: (context, snapshot) {
                Text('Erro: ${snapshot.error}');
                final activity = snapshot.data;
                return Text(activity != null ? activity.title : '');
              },
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder<UserModel>(
                  future: _getUser(userActivity.userId),
                  builder: (context, snapshot) {
                    Text('Erro: ${snapshot.error}');
                    final user = snapshot.data;
                    return Text('Aluno: ${user != null ? user.name : ''}');
                  },
                ),
                Text('Nota: ${userActivity.score}'),
                Text(
                  'Entregue em ${DateFormat('dd/MM/yyyy').format(userActivity.deliveryDate)}',
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 40,
                  child: IconButton(
                    icon: Icon(Icons.edit),
                    tooltip: 'Editar nota',
                    onPressed: () async {
                      return showDialog<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Center(
                              child: Text(
                                'Editar nota',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            content: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: TextFormField(
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                        decimal: true,
                                      ),
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
                                        final double score =
                                            double.parse(value);
                                        if (score < 0 || score > 10) {
                                          return 'A nota deve estar entre 0 e 10';
                                        }
                                        return null;
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
                                  if (_formKey.currentState!.validate()) {
                                    await _updateScore(
                                        userActivity.userId,
                                        userActivity.activityId,
                                        double.parse(_scoreController.text));
                                    Navigator.pop(context, 'Editar');
                                    _fetchUserActivities();
                                  }
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
                    tooltip: 'Deletar avaliação',
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
                                onPressed: () async => {
                                  await _delete(userActivity.userId,
                                      userActivity.activityId),
                                  Navigator.pop(context, 'OK'),
                                  _fetchUserActivities(),
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
