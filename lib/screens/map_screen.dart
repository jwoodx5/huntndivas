// lib/screens/map_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FlutterMap(
        // MapOptions can stay const
        options: const MapOptions(
          initialCenter: LatLng(39.366, -104.60),
          initialZoom: 12,
          minZoom: 3,
          maxZoom: 19,
        ),
        // IMPORTANT: no `const` here
        children: [
          // and no `const` on TileLayer
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.huntndivas.app',
          ),
        ],
      ),
    );
  }
}
