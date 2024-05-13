import 'package:flutter/material.dart';
import 'package:opt120/models/user_model.dart';
import 'package:opt120/services/user_api.dart';

class UserRegisterScreen extends StatelessWidget {
  const UserRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: SizedBox(
          width: 400,
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: UserForm(),
            ),
          ),
        ),
      ),
    );
  }
}

class UserForm extends StatefulWidget {
  const UserForm({super.key});

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _nameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  UserModel? _user;
  bool _obscureText = true;
  double _formProgress = 0;

  void _updateFormProgress() {
    var progress = 0.0;
    final controllers = [
      _nameTextController,
      _emailTextController,
      _passwordTextController
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
      SnackBar(content: Text(message)),
    );
  }

  Future<void> getUser(id) async {
    try {
      final user = await UserApi().getUser(id);
      _user = user;
      _user?.id = user.id;
      _nameTextController.text = _user!.name;
      _emailTextController.text = _user!.email;
      _passwordTextController.text = _user!.password;
    } catch (e) {
      print('Failed to get activity: $e');
    }
  }

  Future<void> create() async {
    var tempMap = {
      "name": _nameTextController.text,
      "email": _emailTextController.text,
      "password": _passwordTextController.text
    };

    UserModel user = UserModel.fromMap(tempMap);

    try {
      String message = await UserApi().create(user);
      Navigator.of(context).pushReplacementNamed('/');
      _nameTextController.clear();
      _emailTextController.clear();
      _passwordTextController.clear();
      _showSnackBar(message);
    } catch (e) {
      print(e);
      Navigator.of(context).pushReplacementNamed('/userRegister');
      _showSnackBar(e.toString());
    }
  }

  Future<void> update() async {
    var tempMap = {
      "name": _nameTextController.text,
      "email": _emailTextController.text,
      "password": _passwordTextController.text
    };

    UserModel user = UserModel.fromMap(tempMap);

    try {
      await UserApi().update(user);
    } catch (e) {
      print('Erro ao editar usuário: $e');
      _showSnackBar(
          "Erro ao editar usuário. Por favor, tente novamente mais tarde.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Form(
          onChanged: _updateFormProgress,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LinearProgressIndicator(value: _formProgress),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text("Cadastro de usuário",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  controller: _nameTextController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nome',
                    hintText: 'Digite seu nome',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  controller: _emailTextController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'Digite sua senha',
                  ),
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
                    suffixIcon: IconButton(
                      splashRadius: 20,
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                      icon: (_obscureText == true)
                          ? Icon(Icons.visibility_off)
                          : Icon(Icons.visibility),
                    ),
                  ),
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
                            Navigator.of(context).pushReplacementNamed('/');
                          }
                        : null,
                    child:
                        const Text("Cadastrar", style: TextStyle(fontSize: 20)),
                  ),
                ),
              )
            ],
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/');
          },
          child: const Text("Já possui uma conta?"),
        ),
      ],
    );
  }
}
