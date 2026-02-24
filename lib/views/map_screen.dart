import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../controllers/map_controller.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  Future<void> _loadData() async {
    final controller = context.read<MapController>();
    await controller.loadAllMarkers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carte touristique'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      body: Consumer<MapController>(
        builder: (context, controller, child) {
          if (controller.isLoading && controller.markers.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.error != null && controller.markers.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Erreur : ${controller.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadData,
                      child: const Text('Réessayer'),
                    ),
                  ],
                ),
              ),
            );
          }

          // Si pas de monuments, affiche juste un message
          if (controller.markers.isEmpty) {
            return const Center(
              child: Text("Aucun monument à afficher sur la carte"),
            );
          }

          // Centrer la caméra sur le premier marqueur
          LatLng initialPosition =
              controller.markers.first.position;

          return Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: initialPosition,
                  zoom: 13,
                ),
                markers: controller.markers,
                onMapCreated: (GoogleMapController c) {
                  _mapController = c;
                },
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
              ),
              if (controller.isLoading)
                const Positioned(
                  top: 16,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}