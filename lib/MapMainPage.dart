import 'dart:math';

import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
import 'package:local_connection_first/singletons/AppData.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

import 'Models/LocalLocation.dart';
import 'Models/LocationLabel.dart';

class MapMainPage extends StatefulWidget {
  const MapMainPage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MapMainPage> createState() => _MapMainPageState();
}

class _MapMainPageState extends State<MapMainPage> {

  double _currentSliderValue = 8;
  final MapController _mapController = MapController();

  LocalLocation? _selectedMarker;

  @override
  void initState() {
    super.initState();
    AppData().updateUserLocation().then((Position position) {
      setState(() {

      });

      _moveMapToCurrentLocation();
      // print("position.longitude__"+position.longitude.toString());
    }).catchError((error) {
      // print("Error updating location: $error");
    });

  }


  // [User Input States]

  Future<void> _moveMapToCurrentLocation() async {
    _mapController.move(LatLng(AppData().currentUserPosition.latitude, AppData().currentUserPosition.longitude), _currentSliderValue);
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MapMainPage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: LatLng(AppData().currentUserPosition.latitude, AppData().currentUserPosition.longitude),
                  initialZoom: _currentSliderValue,
                  onPositionChanged: (MapCamera position, bool hasGesture) {
                    if (hasGesture) {
                      // setState(
                      //       () => _c = CenterOnLocationUpdate.never,
                      // );
                    }
                  },
                  interactionOptions: const InteractionOptions(
                    enableMultiFingerGestureRace: false,
                    // flags: (InteractiveFlag.pinchZoom | InteractiveFlag.drag),
                  ),
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.app',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: AppData().currentLatLong,
                        width: 160,
                        height: 160,
                        child: Icon(Icons.person_pin_circle, size: 24.0),
                      ),
                    ],
                  ),
                  MarkerLayer(
                    markers: AppData().cachedListLocalLocations.map((localLocation) {
                      return Marker(
                        point: LatLng(localLocation.latitude, localLocation.longitude),
                        width: 160,
                        height: 160,
                        child:
                          // Text(LocationLabel.toEnum(localLocation.localLabelStrings.first).title)
                        IconButton(
                          icon: Icon(localLocation.localLabelStrings.isNotEmpty ? LocationLabel.toEnum(localLocation.localLabelStrings.first).icon : LocationLabel.other.icon),
                          color: _selectedMarker?.id == localLocation.id ? Colors.green : Colors.black,
                          onPressed: () {
                            setState(() {
                              _selectedMarker = localLocation;
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),

                ],
              ),
            ),
            SizedBox(
              child: Container(
                // width: 200,
                height: min(250, AppData().cachedListLocalLocations.length*110),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blue,
                    width: 3.0,
                  ),
                ),
                child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: AppData().cachedListLocalLocations.length,
                  itemBuilder: (BuildContext context, int i) {
                    final double relativeDistance = Geolocator.distanceBetween(
                      AppData().cachedListLocalLocations[i].latitude,
                      AppData().cachedListLocalLocations[i].longitude,
                      AppData().currentUserPosition.latitude,
                      AppData().currentUserPosition.longitude
                    );
                    AppData().cachedListLocalLocations.sort((a, b) => relativeDistance.compareTo(relativeDistance));



                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedMarker = AppData().cachedListLocalLocations[i];
                          _currentSliderValue = 18;
                          _mapController.move(LatLng(AppData().cachedListLocalLocations[i].latitude, AppData().cachedListLocalLocations[i].longitude), _currentSliderValue);
                        });
                        print("_selectedMarker.id ${_selectedMarker?.id}");
                      },
                      child: Card.filled(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: _selectedMarker?.id == AppData().cachedListLocalLocations[i].id ? Colors.green : Colors.black, // Change this to your desired color
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: GestureDetector(
                          child: _LocalLocationCard(localLocation: AppData().cachedListLocalLocations[i]),
                        ),
                      )
                    );
                  }
                ),
              ),
            ),
            SizedBox(
              height: 50,
              child: Slider(
                value: _currentSliderValue,
                min: 6,
                max: 20,
                divisions: 14,
                label: _currentSliderValue.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    _currentSliderValue = value;
                    _mapController.move(LatLng(AppData().currentUserPosition.latitude, AppData().currentUserPosition.longitude), _currentSliderValue);
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class _LocalLocationCard extends StatelessWidget {
//   const _LocalLocationCard({required this.cardName});
//   final String cardName;
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 100,
//       child: Center(child: Text(cardName)),
//     );
//   }
// }
class _LocalLocationCard extends StatelessWidget {
  const _LocalLocationCard({required this.localLocation});
  final LocalLocation localLocation;

  @override
  Widget build(BuildContext context) {
    double distanceInMiles = (Geolocator.distanceBetween(localLocation.latitude, localLocation.longitude, AppData().currentUserPosition.latitude, AppData().currentUserPosition.longitude)/1609.344);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Icon(LocationLabel.toEnum(localLocation.localLabelStrings.first).icon),
                Text(
                  "${distanceInMiles.toStringAsFixed(distanceInMiles>1 ? 1 : 2)} miles",
                  style: TextStyle(
                    color: Colors.purple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localLocation.locationNickname,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                Text(
                  localLocation.description,
                  style: const TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  "${(localLocation.dateStart!).month}/${(localLocation.dateStart!).day}/${(localLocation.dateStart!).year} -> ${(localLocation.dateEnd!).month}/${(localLocation.dateEnd!).day}/${(localLocation.dateEnd!).year}",
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey,
                  ),
                ),
                // Text(
                //   "${localLocation.latitude} ${localLocation.longitude}",
                //   style: TextStyle(
                //     fontSize: 12.0,
                //     color: Colors.grey,
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}