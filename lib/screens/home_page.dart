import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/monument_controller.dart';
import '../screens/map_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<MonumentController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Guide Touristique"),
      ),
      body: Column(
        children: [
          // 🔎 Barre de recherche décorative
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Rechercher un lieu...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),

          // 📍 Bouton Voir Carte
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              icon: const Icon(Icons.map),
              label: const Text("Voir la carte"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MapScreen(),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 10),

          // 📋 Liste des monuments
          Expanded(
            child: ListView.builder(
              itemCount: controller.monuments.length,
              itemBuilder: (context, index) {
                final monument = controller.monuments[index];

                return Card(
                  margin: const EdgeInsets.all(10),
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
                    onTap: () {
                      // 🚀 Ouvrir carte centrée sur CE monument
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MapScreenWithPosition(
                            latitude: monument.latitude,
                            longitude: monument.longitude,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}