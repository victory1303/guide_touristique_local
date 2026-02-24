import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MapController with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Set<Marker> markers = {};
  bool isLoading = false;
  String? error;

  Future<void> loadAllMarkers() async {
    isLoading = true;
    notifyListeners();

    try {
      final snapshot = await _firestore.collection('Monuments').get();

      markers.clear();

      for (var doc in snapshot.docs) {
        final data = doc.data();

        final LatLng position = LatLng(
          (data['latitude'] as num).toDouble(),
          (data['longitude'] as num).toDouble(),
        );

        markers.add(
          Marker(
            markerId: MarkerId(doc.id),
            position: position,
            infoWindow: InfoWindow(
              title: data['nom'],
              snippet: data['description'],
            ),
          ),
        );
      }

      error = null;
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }
}