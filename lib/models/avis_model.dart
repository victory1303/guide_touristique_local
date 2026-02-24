class AvisModel {
  String id;
  String monumentId;
  String userId;
  String commentaire;
  double note;
  DateTime date;

  AvisModel({
    required this.id,
    required this.monumentId,
    required this.userId,
    required this.commentaire,
    required this.note,
    required this.date,
  });

  factory AvisModel.fromFirestore(Map<String, dynamic> data, String id) {
    return AvisModel(
      id: id,
      monumentId: data['monumentId'],
      userId: data['userId'],
      commentaire: data['commentaire'],
      note: (data['note'] as num).toDouble(),
      date: DateTime.parse(data['date']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'monumentId': monumentId,
      'userId': userId,
      'commentaire': commentaire,
      'note': note,
      'date': date.toIso8601String(),
    };
  }
}