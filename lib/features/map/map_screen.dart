import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MobilizationMapScreen extends ConsumerStatefulWidget {
  const MobilizationMapScreen({super.key});

  @override
  ConsumerState<MobilizationMapScreen> createState() => _MobilizationMapScreenState();
}

class _MobilizationMapScreenState extends ConsumerState<MobilizationMapScreen> {
  late GoogleMapController mapController;
  final LatLng _kanoCenter = const LatLng(12.0022, 8.5920);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mobilization Map')),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: _kanoCenter, zoom: 12),
        onMapCreated: (controller) => mapController = controller,
        markers: {
          const Marker(
            markerId: MarkerId('kano_center'),
            position: LatLng(12.0022, 8.5920),
            infoWindow: InfoWindow(title: 'Kano HQ', snippet: 'ACF Central Office'),
          ),
        },
      ),
    );
  }
}
