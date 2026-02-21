/// Modèle d'un monument / point d'intérêt (Firestore ou API externe).
class Monument {
  final String id;
  final String nom;
  final double latitude;
  final double longitude;
  final String description;
  final String categorie;
  final String? photoUrl;

  Monument({
    required this.id,
    required this.nom,
    required this.latitude,
    required this.longitude,
    required this.description,
    required this.categorie,
    this.photoUrl,
  });

  factory Monument.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Monument(
      id: documentId,
      nom: data['nom'] ?? '',
      latitude: (data['latitude'] ?? 0.0).toDouble(),
      longitude: (data['longitude'] ?? 0.0).toDouble(),
      description: data['description'] ?? '',
      categorie: data['categorie'] ?? '',
      photoUrl: data['photoUrl'],
    );
  }

  /// Parse la réponse de l'API OpenTripMap (endpoint radius).
  /// Format : { "xid", "name", "point": { "lon", "lat" }, "kinds", ... }
  factory Monument.fromOpenTripMap(Map<String, dynamic> place) {
    final point = place['point'] as Map<String, dynamic>? ?? {};
    final lat = (point['lat'] ?? 0.0).toDouble();
    final lon = (point['lon'] ?? 0.0).toDouble();
    return Monument(
      id: (place['xid'] ?? place['name'] ?? '${lat}_$lon').toString(),
      nom: (place['name'] ?? 'Sans nom').toString(),
      latitude: lat,
      longitude: lon,
      description: (place['wikipedia_extracts']?['text'] ?? place['kinds'] ?? '').toString(),
      categorie: (place['kinds'] ?? 'autre').toString().split(',').first.trim(),
      photoUrl: null,
    );
  }
}
