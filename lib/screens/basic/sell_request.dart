import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:recyclo/screens/basic/buyer_home.dart';
// import 'package:location/location.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
// import 'package:flutter_google_maps_webservices/places.dart';

class FindingBuyerAnimation extends StatefulWidget {
  @override
  _FindingBuyerAnimationState createState() => _FindingBuyerAnimationState();
}

class _FindingBuyerAnimationState extends State<FindingBuyerAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Transform.rotate(
              angle: _animation.value * 2 * 3.14,
              // origin: Offset(50.0, 50.0),
              child: Center(
                child: Icon(
                  Icons.circle_outlined,
                  size: 40,
                  color: Colors.blue,
                ),
              ),
            );
          },
        ),
        Text("Searching for Buyers")
      ],
    );
  }
}

class SellRequest extends StatefulWidget {
  const SellRequest({Key? key}) : super(key: key);

  @override
  State<SellRequest> createState() => _SellRequestState();
}

class _SellRequestState extends State<SellRequest> {
  geo.Position? currentPositionOfUser;
  final TextEditingController addressController = TextEditingController();

  late GoogleMapController googleMapController;
  late Marker userMarker = Marker(markerId: const MarkerId('currentLocation'));
  Set<Marker> markers = {};
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  PanelController _pc = new PanelController();

  @override
  void initState() {
    super.initState();
    userMarker = Marker(markerId: const MarkerId('currentLocation'));
    getCurrentLocationOfUserAndFetchName();
    getCurrentLocation();
    _pc = PanelController();
  }

  Future<void> getCurrentLocationOfUserAndFetchName() async {
    await getCurrentLocationOfUser(); // Get the current location
    getPlaceName(LatLng(
        currentPositionOfUser!.latitude, currentPositionOfUser!.longitude));
  }

  // String _selectedWasteType = 'Plastic';
  String _selectedWasteQuantity = 'Below 1kg';

  List<String> wasteType = ["Plastic", "Paper", "Glass", "e-Waste"];
  List<bool> selectedWaste = [false, false, false, false];

  List<String> _wasteQuantities = [
    'Below 1kg',
    '1 to 5 kg',
    'Above 5 kg',
  ];

  Future<void> getCurrentLocationOfUser() async {
    geo.Position positionOfUser = await geo.Geolocator.getCurrentPosition(
        desiredAccuracy: geo.LocationAccuracy.best);

    currentPositionOfUser = positionOfUser;

    LatLng(currentPositionOfUser!.latitude, currentPositionOfUser!.longitude);
  }

  bool findingBuyer = false;

  //send request logic
  Future<void> sendPickupRequest() async {
    try {
      // Get the selected waste type and quantity
      List<String> selectedWasteTypes = [];
      for (int i = 0; i < wasteType.length; i++) {
        if (selectedWaste[i]) {
          selectedWasteTypes.add(wasteType[i]);
        }
      }

      String wasteQuantity = _selectedWasteQuantity;

      // Get the current location details
      String placeName = addressController.text;
      LatLng currentLocation = userMarker.position;

      // Construct the pickup request data
      Map<String, dynamic> pickupRequestData = {
        'wasteTypes': selectedWasteTypes,
        'wasteQuantity': wasteQuantity,
        'placeName': placeName,
        'location':
            GeoPoint(currentLocation.latitude, currentLocation.longitude),
        'status': 'pending',
      };

      // Send the pickup request to Firestore
      await _firestore.collection('pickupRequests').add(pickupRequestData);

      // Show a success message or navigate to a confirmation screen
      print('Pickup request sent successfully!');

      // Start the custom animation when the pickup request is successful
      setState(() {
        findingBuyer = true;
      });
      await _pc.close(); // Close the SlidingUpPanel
      // Simulate finding the buyer for 3 seconds (replace with your logic)
      await Future.delayed(Duration(seconds: 10));
      // Stop the animation
      setState(() {
        findingBuyer = false;
      });
    } catch (e) {
      print('Error sending pickup request: $e');
      // Handle the error (show an error message, etc.)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: SlidingUpPanel(
            controller: _pc,
            minHeight: 100,
            maxHeight: MediaQuery.of(context).size.height - 200,
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
                  Column(
                    children: [
                      Text(
                        'Waste Type :',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: wasteType.length,
                        itemBuilder: (context, index) {
                          return CheckboxListTile(
                              title: Text(wasteType[index]),
                              value: selectedWaste[index],
                              onChanged: (value) {
                                setState(() {
                                  selectedWaste[index] = value!;
                                });
                              });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        'Waste Quantity:',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      DropdownButton<String>(
                        value: _selectedWasteQuantity,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedWasteQuantity = newValue!;
                          });
                        },
                        items: _wasteQuantities.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => BuyerHome()));
                      sendPickupRequest();
                    },
                    child: Text(
                      'Send Request',
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ),
                  //  if (findingBuyer)
                  //   Center(
                  //     child: FindingBuyerAnimation(),
                  //   ),
                ],
              ),
            ),
            body: Stack(children: [
              GoogleMap(
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
              if (findingBuyer)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: FindingBuyerAnimation(),
                  ),
                ),
            ]),
          ),
        ));
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
