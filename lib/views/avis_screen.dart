import 'package:flutter/material.dart';
import '../controllers/avis_controller.dart';
import '../models/avis_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AvisScreen extends StatefulWidget {
  final String monumentId;

  const AvisScreen({super.key, required this.monumentId});

  @override
  State<AvisScreen> createState() => _AvisScreenState();
}

class _AvisScreenState extends State<AvisScreen> {
  final AvisController _controller = AvisController();
  final TextEditingController _commentController = TextEditingController();
  double _note = 3;

  void _ajouterAvis() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    AvisModel avis = AvisModel(
      id: '',
      monumentId: widget.monumentId,
      userId: user.uid,
      commentaire: _commentController.text,
      note: _note,
      date: DateTime.now(),
    );

    await _controller.ajouterAvis(avis);

    _commentController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Avis ajouté avec succès")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Avis des visiteurs")),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _controller.getAvisParMonument(widget.monumentId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final avisList = snapshot.data!;

                return ListView.builder(
                  itemCount: avisList.length,
                  itemBuilder: (context, index) {
                    final avis = avisList[index];
                    return ListTile(
                      title: Text(avis.commentaire),
                      subtitle: Text("Note: ${avis.note} ⭐"),
                    );
                  },
                );
              },
            ),
          ),
          TextField(
            controller: _commentController,
            decoration: const InputDecoration(
              labelText: "Votre commentaire",
            ),
          ),
          Slider(
            value: _note,
            min: 1,
            max: 5,
            divisions: 4,
            label: _note.toString(),
            onChanged: (value) {
              setState(() {
                _note = value;
              });
            },
          ),
          ElevatedButton(
            onPressed: _ajouterAvis,
            child: const Text("Ajouter Avis"),
          ),
        ],
      ),
    );
  }
}