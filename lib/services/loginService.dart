import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:glossario/DAO/DAO_professor.dart';
import 'package:glossario/screens/homeAluno.dart';
import 'package:glossario/screens/homeProfessor.dart';

class LoginService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DaoProfessor _daoProfessor = DaoProfessor();

  Future<void> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      if (email == emailProfessor && password == senhaProfessor) {
        await _daoProfessor.registraProfessor();
      }

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        if (email == emailProfessor && password == senhaProfessor) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeProfessor()),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeAluno()),
          );
        }
      }
    } catch (e) {
      print('Erro ao fazer login: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Credenciais incorretas, tente novamente')),
      );
    }
  }
}
