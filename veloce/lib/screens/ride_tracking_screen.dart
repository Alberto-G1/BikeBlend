import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class RideTrackingScreen extends StatefulWidget {
  const RideTrackingScreen({super.key});

  @override
  State<RideTrackingScreen> createState() => _RideTrackingScreenState();
}

class _RideTrackingScreenState extends State<RideTrackingScreen> {
  final Location _location = Location();
  GoogleMapController? _controller;

  final List<LatLng> _routeCoords = [];
  final Set<Polyline> _polylines = {};
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _initLocationTracking();
  }

  void _initLocationTracking() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) serviceEnabled = await _location.requestService();

    PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
    }

    final current = await _location.getLocation();
    _updateMap(current);

    _location.onLocationChanged.listen((locationData) {
      final newLatLng = LatLng(locationData.latitude!, locationData.longitude!);

      _routeCoords.add(newLatLng);
      _polylines.add(Polyline(
        polylineId: const PolylineId('ride_path'),
        points: _routeCoords,
        color: Colors.deepPurpleAccent,
        width: 4,
      ));

      setState(() {
        _markers.clear();
        _markers.add(Marker(
          markerId: const MarkerId('current_position'),
          position: newLatLng,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
        ));
      });

      _controller?.animateCamera(CameraUpdate.newLatLng(newLatLng));
    });
  }

  void _updateMap(LocationData current) {
    final startLatLng = LatLng(current.latitude!, current.longitude!);
    _routeCoords.add(startLatLng);
    _markers.add(Marker(
      markerId: const MarkerId("start_point"),
      position: startLatLng,
      infoWindow: const InfoWindow(title: "Start"),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(0.3476, 32.5825), // Kampala fallback
          zoom: 16,
        ),
        onMapCreated: (controller) => _controller = controller,
        markers: _markers,
        polylines: _polylines,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}
