import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import '../../utils/constant/color_constants.dart';
import '../../utils/map_utils.dart';

class MapViewScreen extends StatefulWidget {
  final double? lat;
  final double? lng;
  final String? address;
  final String title;

  const MapViewScreen({
    super.key,
    this.lat,
    this.lng,
    this.address,
    required this.title,
  });

  @override
  State<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> {
  LatLng? _position;
  bool _isLoading = true;
  String? _errorMessage;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _initMap();
  }

  Future<void> _initMap() async {
    bool hasCoords =
        widget.lat != null &&
        widget.lng != null &&
        widget.lat != 0.0 &&
        widget.lng != 0.0;
    bool hasAddress = widget.address != null && widget.address!.isNotEmpty;

    if (hasCoords) {
      _position = LatLng(widget.lat!, widget.lng!);
      _updateMarker(_position!);
      setState(() => _isLoading = false);
    } else if (hasAddress) {
      try {
        List<Location> locations = await locationFromAddress(widget.address!);
        if (locations.isNotEmpty) {
          _position = LatLng(
            locations.first.latitude,
            locations.first.longitude,
          );
          _updateMarker(_position!);
        } else {
          _errorMessage =
              "Could not find the location for address: ${widget.address}";
        }
      } catch (e) {
        _errorMessage =
            "Error finding location for address: ${widget.address}. Error: $e";
      }
      setState(() => _isLoading = false);
    } else {
      setState(() {
        _errorMessage =
            "No location information (coordinates or address) was provided for this item.";
        _isLoading = false;
      });
    }
  }

  void _updateMarker(LatLng position) {
    _markers = {
      Marker(
        markerId: const MarkerId('destination'),
        position: position,
        infoWindow: InfoWindow(title: widget.title, snippet: widget.address),
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Go Back"),
                    ),
                  ],
                ),
              ),
            )
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _position!,
                zoom: 15,
              ),
              onMapCreated: (controller) {
                // Automatically show the info window when map is created
                controller.showMarkerInfoWindow(const MarkerId('destination'));
              },
              markers: _markers,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
      floatingActionButton: _position != null
          ? FloatingActionButton.extended(
              onPressed: () {
                MapUtils.openExternalMap(
                  lat: _position!.latitude,
                  lng: _position!.longitude,
                  address: widget.address,
                );
              },
              backgroundColor: AppColors.primaryColor,
              icon: const Icon(Icons.navigation, color: Colors.white),
              label: const Text(
                "Start Navigation",
                style: TextStyle(color: Colors.white),
              ),
            )
          : null,
    );
  }
}
