import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/monument_model.dart';
import '../utils/constants.dart';

class FirestoreService {
  final CollectionReference<Map<String, dynamic>> _monumentsRef =
      FirebaseFirestore.instance.collection(FirestoreConstants.monumentsCollection);

  Future<List<Monument>> getMonuments() async {
    try {
      final snapshot = await _monumentsRef.get();
      return snapshot.docs.map((doc) {
        return Monument.fromFirestore(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Erreur Firestore: $e');
    }
  }

  Future<void> addMonument(Monument monument) async {
    await _monumentsRef.add({
      'nom': monument.nom,
      'latitude': monument.latitude,
      'longitude': monument.longitude,
      'description': monument.description,
      'categorie': monument.categorie,
      'photoUrl': monument.photoUrl,
    });
  }
}
