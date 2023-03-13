import 'package:flutter/material.dart';
import 'package:mybixbite/Theme/app-theme.dart';

import 'dart:math';

import 'package:flutter_polyline_points/flutter_polyline_points.dart' as pl;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mybixbite/widgets/bottom-navigationbar.dart';

class ShowMap extends StatefulWidget {
  const ShowMap({Key? key}) : super(key: key);

  @override
  _ShowMapState createState() => _ShowMapState();
}

class _ShowMapState extends State<ShowMap> {
  String googleApikey = "AIzaSyDNQDYD_Gf_z1nyammhkEPwOBeP_fP6VYc";

  //String googleApikey = "AIzaSyDk09rnm5B0k3FuLsij7GCLUJAqF7oGVPc";
  GoogleMapController? mapController; //contrller for Google map
  CameraPosition? cameraPosition;

  Position? _currentUserPosition;
  LatLng? startLocation = LatLng(10.2524, 123.8392);
  LatLng endLocation = LatLng(10.3157, 123.8854);

  String location = "Search for services nearby to Rebalance You";
  Set<Marker>? markers = Set(); //markers for google map

  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {}; //polylines to show direction
  bool isHide = false;

  double bottomPaddingOfMap = 0;
  double distance = 0.0;

  @override
  void initState() {
    currentLocation();
    addmarkers();
    super.initState();
  }

  Future currentLocation() async {
    try {
      _currentUserPosition =
          await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      startLocation = LatLng(
        _currentUserPosition!.latitude,
        _currentUserPosition!.longitude,
      );

      await mapController
          ?.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
        target: LatLng(_currentUserPosition!.latitude, _currentUserPosition!.longitude),
        zoom: 14.0,
      )));
      markers!.add(Marker(
        //add start location marker
        markerId: MarkerId(startLocation.toString()),
        position: startLocation!, //position of marker
        infoWindow: InfoWindow(
          //popup info
          title: 'Starting Point ',
          snippet: 'Start Marker',
        ),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  addmarkers() {
    // markers!.add(Marker(
    //   //add start location marker
    //   markerId: MarkerId(startLocation.toString()),
    //   position: startLocation!, //position of marker
    //   infoWindow: InfoWindow(
    //     //popup info
    //     title: 'Starting Point ',
    //     snippet: 'Start Marker',
    //   ),
    //   icon: BitmapDescriptor.defaultMarker, //Icon for Marker
    // ));

    markers!.add(Marker(
      //add distination location marker
      markerId: MarkerId(endLocation.toString()),
      position: endLocation, //position of marker
      infoWindow: InfoWindow(
        //popup info
        title: 'Destination Point ',
        snippet: 'Destination Marker',
      ),
      icon: BitmapDescriptor.defaultMarker, //Icon for Marker
    ));
  }

  // currentLocation() async {
  //   try {
  //     GeoFirePoint? myLocation;
  //     Position? pos =
  //         await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  //
  //     myLocation = GeoFirePoint(pos.latitude, pos.longitude);
  //
  //     startLocation = LatLng(myLocation.latitude, myLocation.longitude);
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
      width: 8,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    mapController?.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    TextTheme _textTheme = Theme.of(context).textTheme;
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Search MyBixBite Service"),
      ),

      //backgroundColor: isDark ? Colors.blueGrey : AppTheme.white,
      //backgroundColor: AppTheme.white,
      bottomNavigationBar: BottomNavBar(index: 1),
      body: Stack(
        children: [
          GoogleMap(
            //Map widget from google_maps_flutter package
            padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
            zoomGesturesEnabled: true,
            //enable Zoom in, out on map
            initialCameraPosition: CameraPosition(
              //innital position in map
              target: startLocation!, //initial position
              zoom: 14.0, //initial zoom level
            ),
            markers: markers!,
            polylines: Set<Polyline>.of(polylines.values),
            //polylines
            mapType: MapType.normal,
            //map type
            onMapCreated: (controller) {
              //method called when map is created
              setState(() {
                mapController = controller;
              });
            },
            onCameraMove: (CameraPosition cameraPositiona) {
              cameraPosition = cameraPositiona;
            },
          ),
          // Positioned(
          //     top: 100,
          //     left: 120.0,
          //     child: Container(
          //       color: Colors.blue,
          //       child: Text(
          //         "Search adsadsadadsa",
          //         style: TextStyle(
          //           color: Colors.black,
          //         ),
          //       ),
          //     )),
          distance == 0.0
              ? Container()
              : Positioned(
                  top: 400,
                  left: 120.0,
                  child: Text(
                    "Total Distance: " + distance.toStringAsFixed(2) + " KM",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  )),
          Positioned(
            top: 10,
            left: 0,
            right: 0,
            //bottom: 0.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 6.0,
                    ),
                    GestureDetector(
                      onTap: () async {
                        var place = await PlacesAutocomplete.show(
                            context: context,
                            apiKey: googleApikey,
                            mode: Mode.overlay,
                            types: [],
                            strictbounds: false,
                            //components: [Component(Component.country, 'us')],
                            //google_map_webservice package
                            onError: (err) {
                              print("Error");
                            });

                        if (place != null) {
                          location = place.description!;

                          //form google_maps_webservice package
                          final plist = GoogleMapsPlaces(
                            apiKey: googleApikey,
                            apiHeaders: await GoogleApiHeaders().getHeaders(),
                            //from google_api_headers package
                          );
                          String placeid = place.placeId ?? "0";
                          final detail = await plist.getDetailsByPlaceId(placeid);
                          final geometry = detail.result.geometry!;
                          final lat = geometry.location.lat;
                          final lang = geometry.location.lng;
                          endLocation = LatLng(lat, lang);

                          //move map camera to selected place with animation
                          mapController?.animateCamera(CameraUpdate.newCameraPosition(
                              CameraPosition(target: endLocation, zoom: 17)));

                          List<LatLng> polylineCoordinates = [];

                          PolylineResult result =
                              await polylinePoints.getRouteBetweenCoordinates(
                            googleApikey,
                            PointLatLng(
                                startLocation!.latitude, startLocation!.longitude),
                            PointLatLng(endLocation.latitude, endLocation.longitude),
                            travelMode: pl.TravelMode.driving,
                          );

                          if (result.points.isNotEmpty) {
                            result.points.forEach((PointLatLng point) {
                              polylineCoordinates
                                  .add(LatLng(point.latitude, point.longitude));
                            });
                          } else {
                            print(result.errorMessage);
                          }

                          addmarkers();
                          addPolyLine(polylineCoordinates);

                          double totalDistance = 0;
                          for (var i = 0; i < polylineCoordinates.length - 1; i++) {
                            totalDistance += calculateDistance(
                                polylineCoordinates[i].latitude,
                                polylineCoordinates[i].longitude,
                                polylineCoordinates[i + 1].latitude,
                                polylineCoordinates[i + 1].longitude);
                          }
                          print(totalDistance);

                          setState(() {
                            distance = totalDistance;
                          });

                          print("LOCATION");
                          print(place.description);
                          print(endLocation);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Card(
                              child: Container(
                                  padding: EdgeInsets.all(0),
                                  width: double.infinity,
                                  child: ListTile(
                                    title: Text(
                                      location,
                                      style: TextStyle(fontSize: 14, color: Colors.grey),
                                    ),
                                    trailing: Icon(
                                      Icons.search,
                                      color: Colors.blue,
                                    ),
                                    dense: true,
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
