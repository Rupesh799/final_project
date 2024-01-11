import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:recyclo/services/buyer_service.dart';
// import 'package:recyclo/screens/basic/feedback.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
// import 'package:flutter_google_maps_webservices/places.dart';
// import 'package:location/location.dart';

class BuyerHome extends StatefulWidget {
  const BuyerHome({Key? key});

  @override
  State<BuyerHome> createState() => _HomeState();
}

class _HomeState extends State<BuyerHome> {
  final BuyerService _buyerService = BuyerService();

  geo.Position? currentPositionOfUser;
  final TextEditingController addressController = TextEditingController();

  late GoogleMapController googleMapController;
  late Marker userMarker = Marker(
      markerId:
          const MarkerId('currentLocation')); // Declare userMarker variable
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    userMarker = Marker(markerId: const MarkerId('currentLocation'));
    getCurrentLocation();
    getCurrentLocationOfUserAndFetchName();
    // listenForPickupRequests();
    //  getCurrentUser();
  }

  Future<void> getCurrentLocationOfUserAndFetchName() async {
    await getCurrentLocationOfUser(); // Get the current location
    getPlaceName(LatLng(
        currentPositionOfUser!.latitude, currentPositionOfUser!.longitude));
  }

  Future<void> getCurrentLocationOfUser() async {
    geo.Position positionOfUser = await geo.Geolocator.getCurrentPosition(
        desiredAccuracy: geo.LocationAccuracy.best);

    currentPositionOfUser = positionOfUser;

    LatLng(currentPositionOfUser!.latitude, currentPositionOfUser!.longitude);
  }

  void listenForPickupRequests() {
    _buyerService
        .getPickupRequestsStream('buyerId')
        .listen((QuerySnapshot snapshot) {
      // Handle incoming pickup requests
      snapshot.docs.forEach((doc) {
        String status = doc['status'];
        if (status == 'pending') {
          // Display a popup or update UI based on the pending request
          showPickupRequestPopup(doc.id);
        }
      });
    });
  }

  void showPickupRequestPopup(String requestId) {
    // Implement a popup UI to display the pickup request
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('New Pickup Request'),
          content: Text('You have a new pickup request!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close'),
            ),
            TextButton(
              onPressed: () {
                acceptPickupRequest(requestId);
                Navigator.pop(context);
              },
              child: Text('Accept'),
            ),
          ],
        );
      },
    );
  }

  void acceptPickupRequest(String requestId) {
    _buyerService.acceptPickupRequest(requestId);
    // Handle the logic for accepting the pickup request
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme:
            const IconThemeData(color: Color.fromARGB(255, 247, 245, 245)),
        title: const Text(
          "Recyclo",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 8, 149, 128),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context,
                  'history_screen'); // Replace with the actual name of your history screen
            },
            icon: const Icon(
              Icons.notifications,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, 'account_screen');
            },
            icon: const Icon(
              Icons.circle,
              color: Colors.white,
            ),
          ),
        ],
      ),

      body: SafeArea(
        child: SlidingUpPanel(
          minHeight: 40,
          maxHeight: MediaQuery.of(context).size.height - 740,
          panel: Container(
            padding: EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 8),
                    height: 5,
                    width: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: addressController,
                  readOnly: true,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    suffixIcon: const Icon(Icons.location_on),
                  ),
                ),
              ],
            ),
          ),
          body: GoogleMap(
            initialCameraPosition: const CameraPosition(
                target: LatLng(27.672468, 85.337924), zoom: 14),
            markers: markers,
            zoomControlsEnabled: false,
            mapType: MapType.normal,
            onMapCreated: (GoogleMapController controller) {
              googleMapController = controller;
            },
            onTap: (LatLng latLng) {
              addOrUpdateMarker(latLng);
              getPlaceName(latLng);
            },
          ),
        ),
      ),

      // body: GoogleMap(
      //   initialCameraPosition: CameraPosition(target: LatLng(27.672468, 85.337924), zoom: 14),
      //   markers: markers,
      //   zoomControlsEnabled: false,
      //   mapType: MapType.normal,
      //   onMapCreated: (GoogleMapController controller) {
      //     googleMapController = controller;
      //   },
      //   onTap: (LatLng latLng) {
      //     _addOrUpdateMarker(latLng);
      //   },
      // ),

//  floatingActionButton: FloatingActionButton.extended(
//         onPressed: () async {
//           // Fetch location on button press
//           _getCurrentLocation();
//         },
//         label: const Text("Current Location"),
//         icon: const Icon(Icons.location_history),
//       ),
    );
  }

  Future<void> getCurrentLocation() async {
    try {
      geo.Position position = await determinePosition();

      setState(() {
        userMarker = Marker(
          markerId: const MarkerId('currentLocation'),
          position: LatLng(position.latitude, position.longitude),
          draggable: true,
          onDragEnd: (newPosition) {
            getPlaceName(newPosition);
          },
        );
        markers.clear();
        markers.add(userMarker);
      });
    } catch (e) {
      print("Error fetching location: $e");
    }
  }

  Future<void> getPlaceName(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude, position.longitude,
          localeIdentifier: 'en_US');

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;

        String thoroughfare = place.thoroughfare ?? '';
        String locality = place.locality ?? '';

        String placeName =
            '${thoroughfare.isNotEmpty ? thoroughfare + ', ' : ''}$locality';

        print("Place Name: $placeName");
        // You can show place name in UI or handle it as required
        setState(() {
          addressController.text = placeName;
        });
      }
    } catch (e) {
      print("Error fetching place name: $e");
    }
  }

  void addOrUpdateMarker(LatLng latLng) {
    setState(() {
      markers.remove(userMarker);
      userMarker = Marker(
        markerId: const MarkerId('currentLocation'),
        position: latLng,
        draggable: true,
        onDragEnd: (newPosition) {
          getPlaceName(newPosition);
        },
      );
      markers.add(userMarker);
    });
  }

  Future<geo.Position> determinePosition() async {
    bool serviceEnabled;
    geo.LocationPermission permission;

    serviceEnabled = await geo.Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw 'Location services are disabled';
    }

    permission = await geo.Geolocator.checkPermission();

    if (permission == geo.LocationPermission.denied) {
      permission = await geo.Geolocator.requestPermission();

      if (permission == geo.LocationPermission.denied) {
        throw 'Location permission denied';
      }
    }

    if (permission == geo.LocationPermission.deniedForever) {
      throw 'Location permissions are permanently denied';
    }

    geo.Position position = await geo.Geolocator.getCurrentPosition();

    return position;
  }
}
