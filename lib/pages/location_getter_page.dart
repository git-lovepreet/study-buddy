import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f_study_buddy/components/button_dark.dart';
import 'package:f_study_buddy/pages/professional_data_page.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../services/auth/auth_service.dart';

class LocationAccessPage extends StatefulWidget {
  @override
  _LocationAccessPageState createState() => _LocationAccessPageState();
}

class _LocationAccessPageState extends State<LocationAccessPage> {
  String _locationMessage = "We need your location to proceed";
  bool _isLocationFetched = false;
  bool _isFetchingLocation = false; // Added loading state

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isFetchingLocation = true; // Start fetching
    });

    PermissionStatus status = await Permission.location.request();
    if (status.isGranted) {
      await _fetchLocation();
    } else if (status.isDenied) {
      setState(() {
        _locationMessage = "Location permission denied. Please allow it from settings.";
        _isLocationFetched = false;
        _isFetchingLocation = false; // Stop fetching
      });
    } else if (status.isPermanentlyDenied) {
      openAppSettings(); // Opens the app settings for the user to enable permissions.
      setState(() {
        _locationMessage = "Location permission permanently denied. Please enable it in settings.";
        _isLocationFetched = false;
        _isFetchingLocation = false; // Stop fetching
      });
    }
  }

  Future<void> _fetchLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Save the location data to Firestore
      await _saveLocationToFirestore(position.latitude, position.longitude);

      setState(() {
        _locationMessage =
        "Your Location:\nLatitude: ${position.latitude}, Longitude: ${position.longitude}";
        _isLocationFetched = true;
        _isFetchingLocation = false; // Stop fetching
      });
    } catch (e) {
      setState(() {
        _locationMessage = "Failed to fetch location: $e";
        _isLocationFetched = false;
        _isFetchingLocation = false; // Stop fetching
      });
    }
  }

  Future<void> _saveLocationToFirestore(double latitude, double longitude) async {
    try {
      final String? userID = AuthService().getUId();

      // Here, you can fetch the city name if needed using reverse geocoding APIs
      await _firestore.collection('Users').doc(userID).set({
        'location': {
          'latitude': latitude,
          'longitude': longitude,
        }
      },
        SetOptions(merge: true),);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save location: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: Center(
                  child: Icon(Icons.arrow_back_ios_new,
                      size: 18,
                      color: Theme.of(context).colorScheme.background))),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 40),
            // Top Icon or Illustration
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                  )
                ],
              ),
              child: Center(
                child: Icon(
                  Icons.location_on,
                  size: 80,
                  color: Theme.of(context).colorScheme.background,
                ),
              ),
            ),
            SizedBox(height: 20),
            // Title Text
            Text(
              "Allow Location Access",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            // Subtitle Text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "We use your location to show nearby matches and personalized recommendations. Your data will remain secure.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30),
            // Location Status
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                _locationMessage,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            // Get Location Button with CircularProgressIndicator
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed: _isFetchingLocation ? null : _getCurrentLocation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: _isFetchingLocation
                    ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                    : Text(
                  "Allow Location",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.background,
                  ),
                ),
              ),
            ),
            Spacer(),
            DarkButton(
              onTap: _isLocationFetched
                  ? () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfessionalDataPage(newUser: true,)));
              }
                  : null,
              text: "Next",
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
