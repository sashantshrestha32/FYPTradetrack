import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../../utils/constant/color_constants.dart';

class MapPickerScreen extends StatefulWidget {
  const MapPickerScreen({super.key});
  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  LatLng _currentPosition = const LatLng(
    27.7172,
    85.3240,
  ); // Default to Kathmandu
  bool _isLoading = true;
  String _selectedAddress = "Move map to select location";

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => _isLoading = false);
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() => _isLoading = false);
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() => _isLoading = false);
      return;
    }

    final position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
      _isLoading = false;
    });

    _getAddressFromLatLng(_currentPosition);
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        // Construct a meaningful address/location string
        // Priority: Locality (City) -> SubLocality -> AdministrativeArea
        String location = "";
        if (place.locality != null && place.locality!.isNotEmpty) {
          location = place.locality!;
        } else if (place.subLocality != null && place.subLocality!.isNotEmpty) {
          location = place.subLocality!;
        } else if (place.administrativeArea != null &&
            place.administrativeArea!.isNotEmpty) {
          location = place.administrativeArea!;
        }

        // Add street or name if available for more detail if needed,
        // but user asked for "location (city area)"
        if (place.thoroughfare != null && place.thoroughfare!.isNotEmpty) {
          if (location.isNotEmpty) {
            location = "${place.thoroughfare}, $location";
          } else {
            location = place.thoroughfare!;
          }
        }

        setState(() {
          _selectedAddress = location.isNotEmpty
              ? location
              : "Unknown Location";
        });
      }
    } catch (e) {
      debugPrint("Error getting address: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pick Location"),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _currentPosition,
                zoom: 15,
              ),
              onMapCreated: (controller) {
              },
              onCameraMove: (position) {
                _currentPosition = position.target;
              },
              onCameraIdle: () {
                _getAddressFromLatLng(_currentPosition);
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),

          // Center Marker
          if (!_isLoading)
            const Center(
              child: Icon(Icons.location_pin, size: 50, color: Colors.red),
            ),

          // Bottom Sheet for selection
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Selected Location:",
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _selectedAddress,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, {
                          'lat': _currentPosition.latitude,
                          'long': _currentPosition.longitude,
                          'address': _selectedAddress,
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Confirm Location",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
