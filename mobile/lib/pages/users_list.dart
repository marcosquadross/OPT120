import 'package:flutter/material.dart';
import 'package:opt120/models/activity_model.dart';
import 'package:opt120/models/user_model.dart';
import 'package:opt120/services/user_api.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final _nameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  UserModel? _user;
  List<UserModel> users = [];
  List<ActivityModel> activities = [];
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _fetchUsers() async {
    try {
      final usersList = await UserApi().getUsers();
      setState(() {
        users = usersList;
      });
    } catch (e) {
      print('Failed to fetch users: $e');
    }
  }

  Future<void> _delete(id) async {
    try {
      await UserApi().delete(id);
      _showSnackBar("Usuário deletado com sucesso!");
    } catch (e) {
      print('Failed to delete user: $e');
      _showSnackBar("Erro ao deletar usuário!");
    }
  }

  Future<void> getUser(id) async {
    try {
      final user = await UserApi().getUser(id);
      _user = user;
      _user?.id = user.id;
      _nameTextController.text = _user!.name;
      _emailTextController.text = _user!.email;
      _passwordTextController.text = "";
    } catch (e) {
      print('Failed to get activity: $e');
    }
  }

  Future<void> update(id) async {
    var tempMap = {
      "id": id,
      "name": _nameTextController.text,
      "email": _emailTextController.text,
      "password": _passwordTextController.text
    };

    UserModel user = UserModel.fromMap(tempMap);

    try {
      String message = await UserApi().update(user);
      Navigator.of(context).pushReplacementNamed('/userList');
      _nameTextController.clear();
      _emailTextController.clear();
      _passwordTextController.clear();
      _showSnackBar(message);
    } catch (e) {
      print(e);
      Navigator.of(context).pushReplacementNamed('/userList');
      _showSnackBar(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Usuários", style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: false,
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return ListTile(
            title: Text(user.name),
            subtitle: Text(user.email),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 40,
                  child: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () async {
                      await getUser(user.id);
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
                                      "Editar usuário",
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
                                      controller: _nameTextController,
                                      decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: 'Nome'),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: TextFormField(
                                      controller: _emailTextController,
                                      decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: 'Email'),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: TextFormField(
                                      controller: _passwordTextController,
                                      obscureText: _obscureText,
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(),
                                        labelText: 'Senha',
                                        hintText: 'Digite sua senha',
                                      ),
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
                                  await update(user.id);
                                  Navigator.pop(context, 'Editar');
                                  _fetchUsers();
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
                            title: const Text('Deletar Usuário'),
                            content: const Text(
                                'Deseja realmente deletar este usuário?'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, 'Cancelar'),
                                child: const Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await _delete(user.id);
                                  Navigator.pop(context, 'OK');
                                  _fetchUsers();
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
