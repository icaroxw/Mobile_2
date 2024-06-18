import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glossario/DAO/DAO_aluno.dart';
import 'package:glossario/firebase_options.dart';
import 'package:glossario/services/cadastroService.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Cadastro(),
    );
  }
}

class Cadastro extends StatefulWidget {
  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController matriculationController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final DaoAluno _authAluno = DaoAluno();

  String? nameError;
  String? matriculationError;
  String? emailError;
  String? passwordError;
  String? confirmPasswordError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Cadastro',
                style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 40.0),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                  errorText: nameError,
                ),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: matriculationController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(6),
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  labelText: 'Código de Matrícula',
                  border: OutlineInputBorder(),
                  errorText: matriculationError,
                ),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'E-mail Institucional',
                  border: OutlineInputBorder(),
                  errorText: emailError,
                ),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(),
                  errorText: passwordError,
                ),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirmar Senha',
                  border: OutlineInputBorder(),
                  errorText: confirmPasswordError,
                ),
              ),
              SizedBox(height: 40.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      var validationResults = CadastroService.validateCadastro(
                        name: nameController.text,
                        matriculation: matriculationController.text,
                        email: emailController.text,
                        password: passwordController.text,
                        confirmPassword: confirmPasswordController.text,
                      );
                      nameError = validationResults['Nome'];
                      matriculationError =
                          validationResults['Código de Matrícula'];
                      emailError = validationResults['E-mail Institucional'];
                      passwordError = validationResults['Senha'];
                      confirmPasswordError =
                          validationResults['Confirmar Senha'];
                    });

                    if (nameError == null &&
                        matriculationError == null &&
                        emailError == null &&
                        passwordError == null &&
                        confirmPasswordError == null) {
                      // Se todas as validações passaram, registra o aluno
                      String? result = await _authAluno.registerAluno(
                        email: emailController.text,
                        password: passwordController.text,
                        codMatricula: matriculationController.text,
                        nome: nameController.text,
                      );

                      if (result != null && result.contains('Erro')) {
                        showMessage(context, result);
                      } else {
                        showMessage(context, 'Cadastro realizado com sucesso!');
                      }
                    }
                  },
                  child: Text('Cadastrar'),
                ),
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Já tem uma conta?'),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      ' Faça login',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
