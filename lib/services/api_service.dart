import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../models/monument_model.dart';

class ApiService {
  static const String _baseUrl =
      'https://api.opentripmap.com/0.1/en/places/radius';

  String? get _apiKey => dotenv.env['OPENTRIPMAP_API_KEY'];

  /// Récupère les lieux autour d'un point (OpenTripMap).
  /// [radius] en mètres.
  Future<List<Monument>> fetchPlaces(
    double lat,
    double lon, {
    int radius = 5000,
  }) async {
    if (_apiKey == null || _apiKey!.isEmpty || _apiKey!.contains('REMPLACER')) {
      throw Exception(
          'Clé API OpenTripMap manquante. Ajoutez OPENTRIPMAP_API_KEY dans .env');
    }

    final url = Uri.parse(
      '$_baseUrl?radius=$radius&lon=$lon&lat=$lat&format=json&apikey=$_apiKey',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body) as List<dynamic>;
        return data
            .map((e) => Monument.fromOpenTripMap(e as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Erreur API ${response.statusCode}');
      }
    } catch (e) {
      throw Exception("Échec de l'appel API: $e");
    }
  }
}
