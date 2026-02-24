import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import 'login_screen.dart';
import '../controllers/monument_controller.dart';
import '../models/monument_model.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthController>(context, listen: false);
    final MonumentController controller = MonumentController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Guide Touristique Local"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              try {
                await auth.logout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => LoginScreen()),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Erreur logout : $e")),
                );
              }
            },
          ),
        ],
      ),
      body: StreamBuilder<List<MonumentModel>>(
        stream: controller.getMonuments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("Aucun monument trouvé"),
            );
          }

          final monuments = snapshot.data!;

          return ListView.builder(
            itemCount: monuments.length,
            itemBuilder: (context, index) {
              final monument = monuments[index];

              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                 leading: Image.network(
                   monument.imageUrl,
                   width: 60,
                   fit: BoxFit.cover,
                   errorBuilder: (context, error, stackTrace) {
                   return const Icon(Icons.image_not_supported);
                        },
                     ),
                  title: Text(monument.nom),
                  subtitle: Text(monument.description),
                ),
              );
            },
          );
        },
      ),
    );
  }
}