import 'dart:async';
import 'package:ewaste/screens/residents/request_pickup_screen.dart';
import 'package:ewaste/widgets/configMaps.dart';
import 'package:ewaste/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:search_map_place_updated/search_map_place_updated.dart';
import 'package:ewaste/screens/residents/resident_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class ResidentMapsScreen extends StatefulWidget {
  const ResidentMapsScreen({super.key});

  @override
  State<ResidentMapsScreen> createState() => _ResidentMapsScreenState();
}

class _ResidentMapsScreenState extends State<ResidentMapsScreen> {
  final Completer<GoogleMapController> _controllerGoogleMap =
      Completer<GoogleMapController>();

  GoogleMapController? newGoogleMapController;

  final Set<Marker> _markers = {};

  String? locationName;
  LatLng? pressedLatLng;
  Position? currentPosition;
  var geolocator = Geolocator();

  // To locate the user current position
  void locatePosition() async {
    // ignore: unused_local_variable
    LocationPermission permission = await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    LatLng latLngPosition = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition =
        new CameraPosition(target: latLngPosition, zoom: 14);
    newGoogleMapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  // BottomShet Method
  void showLocationBottomSheet() {
    String locationInfo = locationName ??
        'Coordinates: ${pressedLatLng?.latitude ?? ""}, ${pressedLatLng?.longitude ?? ""}';

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: 200, // Adjust the height as needed
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display the location name here
              Text(
                'Location Name: $locationInfo',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 60),
              // Add the "Next" button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: CustomButton(
                  text: 'Next',
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            RequestPickUpScreen(location: locationInfo),
                      ),
                      (route) => false,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // To move the marker when long-press on the screen
  void onMapLongPress(LatLng pressedLatLng) async {
    setState(() {
      _markers.clear(); // Clear existing markers
      _markers.add(
        Marker(
          markerId: const MarkerId('movableMarker'),
          position: pressedLatLng,
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ),
      );
    });

    // Perform reverse geocoding and get the location name
    try {
      final List<Placemark> placemarks = await placemarkFromCoordinates(
        pressedLatLng.latitude,
        pressedLatLng.longitude,
      );
      locationName = placemarks.isNotEmpty
          ? "${placemarks[0].locality}, ${placemarks[0].thoroughfare}"
          : 'Unknown Location';
    } catch (e) {
      locationName = 'Unknown Location';
    }

    // Show the bottom sheet with the location name
    showLocationBottomSheet();
  }

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Map Integration
          GoogleMap(
            padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 25),
            initialCameraPosition: _kGooglePlex,
            markers: _markers,
            onLongPress: onMapLongPress,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: true,
            zoomGesturesEnabled: true,
            mapType: MapType.normal,
            mapToolbarEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;
              locatePosition();
            },
          ),
          // For the back arrow
          Center(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 110, horizontal: 25),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ResidentScreen()),
                          (route) => false),
                      child: const Icon(Icons.arrow_back),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // For search bar
          Padding(
            padding: const EdgeInsets.all(35),
            child: SearchMapPlaceWidget(
              bgColor: Colors.white,
              textColor: Colors.black,
              hasClearButton: true,
              placeType: PlaceType.geocode,
              placeholder: 'Enter Pick Up Location',
              apiKey: mapKey,
              onSelected: (Place place) async {
                Geolocation? geolocation = await place.geolocation;
                newGoogleMapController!.animateCamera(
                    CameraUpdate.newLatLng(geolocation!.coordinates));
                newGoogleMapController!.animateCamera(
                    CameraUpdate.newLatLngBounds(geolocation.bounds, 0));

                setState(() {
                  _markers.clear();
                  _markers.add(Marker(
                    markerId: const MarkerId('searchResult'),
                    position: geolocation.coordinates,
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueGreen),
                  ));
                });
                // Perform reverse geocoding and get the location name
                try {
                  final List<Placemark> placemarks =
                      await placemarkFromCoordinates(
                    pressedLatLng!.latitude,
                    pressedLatLng!.longitude,
                  );
                  locationName = placemarks.isNotEmpty
                      ? "${placemarks[0].locality}, ${placemarks[0].thoroughfare}"
                      : 'Unknown Location';
                } catch (e) {
                  locationName = 'Unknown Location';
                }
                // Show the bottom sheet with the location name
                showLocationBottomSheet();
              },
            ),
          ),
        ],
      ),
    );
  }
}


















// setState(() {
    //   _markers.add(Marker(
    //     markerId: const MarkerId('userLocation'),
    //     position: LatLng(position.latitude, position.longitude),
    //     icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    //   ));
    // });






// Showing the container with the location name
      // _bottomContainer = Container(
      //   height: 300,
      //   color: Colors.white, // Customize the container's appearance
      //   child: Padding(
      //     padding: const EdgeInsets.only(top: 90.0, right: 20, left: 20),
      //     child: Column(
      //       children: [
      //         // Display the location name here
      //         const Text(
      //           'Location Name: Your Location Name',
      //           style: TextStyle(fontSize: 18),
      //         ),
      //         const SizedBox(
      //           height: 50,
      //         ),
      //         // Add the "Next" button
      //         SizedBox(
      //           width: MediaQuery.of(context).size.width,
      //           height: 50,
      //           child: CustomButton(
      //               text: 'Next',
      //               onPressed: () {
      //                 Navigator.pushAndRemoveUntil(
      //                     context,
      //                     MaterialPageRoute(
      //                         builder: (context) =>
      //                             const RequestPickUpScreen()),
      //                     (route) => false);
      //               }),
      //         )
      //       ],
      //     ),
      //   ),
      // );











// For the BottomContainer
          // const SizedBox(height: 50),
          // Align(alignment: Alignment.bottomCenter, child: _bottomContainer),

          // For the button
          // const SizedBox(height: 700),
          // Padding(
          //   padding: const EdgeInsets.only(top: 700, right: 35, left: 35),
          //   child: SizedBox(
          //     width: MediaQuery.of(context).size.width,
          //     height: 50,
          //     child: CustomButton(
          //         text: 'Next',
          //         onPressed: () {
          //           Navigator.pushAndRemoveUntil(
          //               context,
          //               MaterialPageRoute(
          //                   builder: (context) => const RequestPickUpScreen()),
          //               (route) => false);
          //         }),
          //   ),
          // ),