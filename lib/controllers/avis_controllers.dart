import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/avis_model.dart';

class AvisController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> ajouterAvis(AvisModel avis) async {
    await _firestore.collection('avis').add(avis.toMap());
  }

  Future<void> modifierAvis(AvisModel avis) async {
    await _firestore.collection('avis').doc(avis.id).update(avis.toMap());
  }

  Future<void> supprimerAvis(String id) async {
    await _firestore.collection('avis').doc(id).delete();
  }

  Stream<List<AvisModel>> getAvisParMonument(String monumentId) {
    return _firestore
        .collection('avis')
        .where('monumentId', isEqualTo: monumentId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => AvisModel.fromFirestore(doc.data(), doc.id))
            .toList());
  }
}
Future<List<Map<String, dynamic>>> genererItineraire(
    List<Map<String, dynamic>> monuments,
    double userLat,
    double userLng) async {

  List<Map<String, dynamic>> suggestions = [];

  for (var monument in monuments) {

    double lat = monument['latitude'];
    double lng = monument['longitude'];

    double distance =
        (userLat - lat).abs() + (userLng - lng).abs();

    QuerySnapshot avisSnapshot = await _firestore
        .collection('avis')
        .where('monumentId', isEqualTo: monument['id'])
        .get();

    double moyenne = 0;

    if (avisSnapshot.docs.isNotEmpty) {
      moyenne = avisSnapshot.docs
              .map((doc) => doc['note'] as num)
              .reduce((a, b) => a + b) /
          avisSnapshot.docs.length;
    }

    double score = (5 - distance) + moyenne;

    suggestions.add({
      'monument': monument,
      'score': score,
    });
  }

  suggestions.sort((a, b) =>
      b['score'].compareTo(a['score']));

  return suggestions;
}