import 'dart:async';
import 'package:ewaste/screens/wasteCollectors/waste_collector_screen.dart';
import 'package:ewaste/widgets/configMaps.dart';
import 'package:ewaste/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:location/location.dart';
import 'package:search_map_place_updated/search_map_place_updated.dart';
import 'package:geocoding/geocoding.dart';

class MapRouteScreen extends StatefulWidget {
  const MapRouteScreen({super.key, required this.residentLocation});
  final String residentLocation;

  @override
  State<MapRouteScreen> createState() => _MapRouteScreenState();
}

class _MapRouteScreenState extends State<MapRouteScreen> {
  final Completer<GoogleMapController> _controllerGoogleMap =
      Completer<GoogleMapController>();

  GoogleMapController? newGoogleMapController;

  static LatLng destination = const LatLng(0, 0);
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  List<LatLng> polylineCoordinates = [];
  Position? currentPosition;
  var geolocator = Geolocator();

  // To locate the user current position
  void getCurrentLocation() async {
    // ignore: unused_local_variable
    LocationPermission permission = await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;
    getPloyPoints();

    LatLng latLngPosition = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 14);
    newGoogleMapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  // Convert String location to LatLng
  void convertStringToLatLng(String locationString) async {
    try {
      List<Location> locations = await locationFromAddress(locationString);
      if (locations.isNotEmpty) {
        setState(() {
          destination = LatLng(
            locations[0].latitude,
            locations[0].longitude,
          );
        });
      }
    } catch (e) {
      print('Error converting string to LatLng: $e');
    }
  }

  void getPloyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      mapKey,
      PointLatLng(
          currentPosition?.latitude ?? 0.0, currentPosition?.longitude ?? 0.0),

      // PointLatLng(currentPosition!.latitude, currentPosition!.longitude),
      PointLatLng(destination.latitude, destination.longitude),
    );
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        );
      }
      setState(() {});
    }
  }

  // final StreamController<Position> _locationStreamController =
  //     StreamController<Position>();

  @override
  void initState() {
    getCurrentLocation();
    convertStringToLatLng(widget.residentLocation);
    getPloyPoints();
    super.initState();
  }

  // @override
  // void dispose() {
  //   _locationStreamController.close();
  //   super.dispose();
  // }

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
            polylines: {
              Polyline(
                polylineId: const PolylineId('route'),
                points: polylineCoordinates,
                color: const Color.fromARGB(255, 105, 68, 255),
                width: 6,
              ),
            },
            markers: {
              Marker(
                markerId: const MarkerId("currentPosition"),
                position: LatLng(currentPosition?.latitude ?? 0.0,
                    currentPosition?.longitude ?? 0.0),

                // position: currentPosition != null
                //     ? LatLng(
                //         currentPosition!.latitude, currentPosition!.longitude)
                //     : const LatLng(0.0, 0.0),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueBlue),
              ),
              Marker(
                markerId: const MarkerId('destination'),
                position: destination,
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueRed),
              ),
            },
            // onLongPress: onMapLongPress,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: true,
            zoomGesturesEnabled: true,
            mapType: MapType.normal,
            mapToolbarEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;
              getCurrentLocation();
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
                              builder: (context) =>
                                  const WasteCollectorScreen()),
                          (route) => false),
                      child: const Icon(Icons.arrow_back),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // For search bar
          // Padding(
          //   padding: const EdgeInsets.all(35),
          //   child: SearchMapPlaceWidget(
          //     bgColor: Colors.white,
          //     textColor: Colors.black,
          //     hasClearButton: true,
          //     placeType: PlaceType.geocode,
          //     placeholder: 'Enter Pick Up Location',
          //     apiKey: mapKey,
          //     onSelected: (Place place) async {
          //       Geolocation? geolocation = await place.geolocation;
          //       newGoogleMapController!.animateCamera(
          //           CameraUpdate.newLatLng(geolocation!.coordinates));
          //       newGoogleMapController!.animateCamera(
          //           CameraUpdate.newLatLngBounds(geolocation.bounds, 0));
          //       setState(() {
          //         _markers.clear();
          //         _markers.add(Marker(
          //           markerId: const MarkerId('searchResult'),
          //           position: geolocation.coordinates,
          //           icon: BitmapDescriptor.defaultMarkerWithHue(
          //               BitmapDescriptor.hueGreen),
          //         ));
          //       });
          //       // Perform reverse geocoding and get the location name
          //       try {
          //         final List<Placemark> placemarks =
          //             await placemarkFromCoordinates(
          //           pressedLatLng!.latitude,
          //           pressedLatLng!.longitude,
          //         );
          //         locationName = placemarks.isNotEmpty
          //             ? "${placemarks[0].locality}, ${placemarks[0].thoroughfare}"
          //             : 'Unknown Location';
          //       } catch (e) {
          //         locationName = 'Unknown Location';
          //       }
          //       // Show the bottom sheet with the location name
          //       // showLocationBottomSheet();
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}
