import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/monument_model.dart';
import '../services/api_service.dart';
import '../services/firestore_service.dart';

class MapController extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final ApiService _apiService = ApiService();

  Set<Marker> _markers = {};
  Set<Marker> get markers => Set.from(_markers);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> loadMonumentsFromFirestore() async {
    _setLoading(true);
    try {
      final monuments = await _firestoreService.getMonuments();
      _addMarkersFromMonuments(monuments);
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadPlacesFromApi(LatLng center, {int radius = 5000}) async {
    _setLoading(true);
    try {
      final places = await _apiService.fetchPlaces(
        center.latitude,
        center.longitude,
        radius: radius,
      );
      _addMarkersFromMonuments(places);
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  /// Charge Firestore et API en parallèle et fusionne les marqueurs.
  Future<void> loadAllMarkers(LatLng center, {int radius = 5000}) async {
    _setLoading(true);
    _markers.clear();
    _error = null;

    try {
      final results = await Future.wait([
        _firestoreService.getMonuments(),
        _apiService.fetchPlaces(center.latitude, center.longitude, radius: radius),
      ]);

      final firestoreMonuments = results[0] as List<Monument>;
      final apiMonuments = results[1] as List<Monument>;

      _addMarkersFromMonuments(firestoreMonuments);
      _addMarkersFromMonuments(apiMonuments);
    } catch (e) {
      _error = e.toString();
      // Tenter au moins Firestore seul en secours
      try {
        final monuments = await _firestoreService.getMonuments();
        _addMarkersFromMonuments(monuments);
        _error = null;
      } catch (_) {}
    } finally {
      _setLoading(false);
    }
  }

  void _addMarkersFromMonuments(List<Monument> monuments) {
    for (final monument in monuments) {
      _markers.add(
        Marker(
          markerId: MarkerId(monument.id),
          position: LatLng(monument.latitude, monument.longitude),
          infoWindow: InfoWindow(
            title: monument.nom,
            snippet: monument.description.length > 50
                ? '${monument.description.substring(0, 50)}...'
                : monument.description,
          ),
        ),
      );
    }
    notifyListeners();
  }

  void clearMarkers() {
    _markers.clear();
    _error = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    if (value) _error = null;
    notifyListeners();
  }
}
