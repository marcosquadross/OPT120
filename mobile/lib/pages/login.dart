import 'package:flutter/material.dart';
import '../services/user_api.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LoginForm(),
              RegisterRow(),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;

  var snackBar = const SnackBar(
    content: Text('Login ou Senha incorretos!', style: TextStyle(fontSize: 17)),
    backgroundColor: Colors.red,
  );

  double _formProgress = 0;

  void _updateFormProgress() {
    var progress = 0.0;
    final controllers = [_emailController, _passwordController];

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

  Future<void> _login() async {
    try {
      String response = await UserApi()
          .login(_emailController.text, _passwordController.text);
      Navigator.of(context).pushReplacementNamed('/home');
      _emailController.clear();
      _passwordController.clear();
      ;
      _showSnackBar(response);
    } catch (e) {
      print('Erro durante o login: $e');
      Navigator.of(context).pushReplacementNamed('/');
      _showSnackBar(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQuery.of(context).size;
    return Form(
      onChanged: _updateFormProgress,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  "Login",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'Digite seu email',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  controller: _passwordController,
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
                            _login();
                          }
                        : null,
                    child: const Text("Entrar", style: TextStyle(fontSize: 20)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RegisterRow extends StatefulWidget {
  const RegisterRow({super.key});

  @override
  State<RegisterRow> createState() => _RegisterRowState();
}

class _RegisterRowState extends State<RegisterRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        const Text(
          "Não tem uma conta?",
          style: TextStyle(
            color: Color(0xff707070),
          ),
        ),
        TextButton(
          child: const Text("Registre-se"),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/userRegister');
          },
        ),
      ],
    );
  }
}
