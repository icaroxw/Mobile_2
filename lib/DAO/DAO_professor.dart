import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:glossario/screens/homeProfessor.dart';

const String emailProfessor = 'professor@unaerp.br';
const String senhaProfessor = 'administrador123';

class DaoProfessor {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> registraProfessor() async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: emailProfessor,
        password: senhaProfessor,
      );
      print('professor criado ${userCredential.user?.uid}');
      
    } catch (e) {
      print('$e');
    }
  }
}
