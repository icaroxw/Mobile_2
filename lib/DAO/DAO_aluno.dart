import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DaoAluno {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> registerAluno({
    required String email,
    required String password,
    required String codMatricula,
    required String nome,
  }) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('foi ${userCredential.user?.uid}');

      await _firestore.collection('Aluno').add({
        'cod_matricula': codMatricula,
        'nome': nome,
      });
      print('foi');

      return null;
    } catch (e) {
      print('$e');
      return '${e.toString()}';
    }
  }
}
