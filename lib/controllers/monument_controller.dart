import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/monument_model.dart';

class MonumentController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<MonumentModel>> getMonuments() {
    return _firestore.collection('Monuments').snapshots().map(
      (snapshot) => snapshot.docs.map(
        (doc) => MonumentModel.fromFirestore(
          doc.data(),
          doc.id,
        ),
      ).toList(),
    );
  }
}