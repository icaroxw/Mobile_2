import 'package:cloud_firestore/cloud_firestore.dart';

class DAOTermo {
  final CollectionReference termCollection =
      FirebaseFirestore.instance.collection('termos_tecnicos');

  Future<void> addTermo(Map<String, dynamic> termo) async {
    await termCollection.add(termo);
  }

  Future<void> updateTermo(String id, Map<String, dynamic> termo) async {
    await termCollection.doc(id).update(termo);
  }

  Future<void> deleteTermo(String id) async {
    await termCollection.doc(id).delete();
  }

  Stream<QuerySnapshot> getTermos() {
    return termCollection.snapshots();
  }
}
