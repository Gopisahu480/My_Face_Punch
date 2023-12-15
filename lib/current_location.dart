import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class Homepage1 extends StatefulWidget {
  @override
  _HomepageState1 createState() => _HomepageState1();
}

class _HomepageState1 extends State<Homepage1> {
  String location = 'Null, Press Button';
  String address = 'search';

  @override
  void initState() {
    super.initState();
    _updateLocationAndAddress();
  }

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      throw 'Location services are disabled.';
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw 'Location permissions are denied.';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw 'Location permissions are permanently denied.';
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<void> _updateLocationAndAddress() async {
    try {
      Position position = await _getGeoLocationPosition();
      setState(() {
        location = 'Lat: ${position.latitude}, Long: ${position.longitude}';
      });

      await _getAddressFromLatLong(position);
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _getAddressFromLatLong(Position position) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks.isNotEmpty) {
      Placemark place = placemarks[0];
      setState(() {
        address =
            '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15), // Add padding to control the border width
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 1.0, // Set the border width
        ),
        borderRadius:
            BorderRadius.circular(12.0), // Optional: Add border radius
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            const Icon(
              Icons.location_on, // Use the location_on icon
              size: 25.0,
              color: const Color.fromARGB(255, 5, 81, 143),
            ),
            ShaderMask(
                shaderCallback: (bounds) => LinearGradient(colors: [
                  Colors.grey.shade800,
                  Colors.grey,
                ]).createShader(bounds),
                child: Text(
                 '${address}',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                )
                ),
          ],
        ),
      ),
    );
  }
}
