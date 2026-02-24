
class MonumentModel {
  final String id;
  final String nom;
  final String description;
  final double latitude;
  final double longitude;
  final String imageUrl;

  MonumentModel({
    required this.id,
    required this.nom,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.imageUrl,
  });

  factory MonumentModel.fromFirestore(
      Map<String, dynamic> data,
      String id,
  ) {
    return MonumentModel(
      id: id,
      nom: data['nom'],
      description: data['description'],
      latitude: (data['latitude'] as num).toDouble(),
      longitude: (data['longitude'] as num).toDouble(),
      imageUrl: data['imageUrl'],
    );
  }
}

