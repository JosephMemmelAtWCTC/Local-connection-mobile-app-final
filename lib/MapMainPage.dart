import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
import 'package:local_connection_first/singletons/AppData.dart';
import 'package:local_connection_first/helpers/LocationHelper.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

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

  double _currentSliderValue = 10;
  final MapController _mapController = MapController();

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

  // Future<void> _getUserCurrentLocation() async {
  //   final position = await Geolocator.getCurrentPosition(
  //     desiredAccuracy: LocationAccuracy.high,
  //   );
  //   setState(() {
  //     AppData().currentUserPosition = LatLng(position.latitude, position.longitude) as Position;
  //     // print("position.latitude, position.longitude = ${position.latitude} ${position.longitude}");
  //     print("AppData().currentUserPosition_"+AppData().currentUserPosition.longitude.toString());
  //   });
  // }


  // [User Input States]

  Future<void> _moveMapToCurrentLocation() async {
    await Future.delayed(Duration(milliseconds: 500)); // Wait a bit for widget to render
    _mapController.move(new LatLng(AppData().currentUserPosition.latitude, AppData().currentUserPosition.longitude), _currentSliderValue);
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
                  initialCenter: new LatLng(AppData().currentUserPosition.latitude, AppData().currentUserPosition.longitude)?? const LatLng(0,0),
                  initialZoom: _currentSliderValue,
                  onPositionChanged: (MapCamera position, bool hasGesture) {
                    if (hasGesture) {
                      // setState(
                      //       () => _c = CenterOnLocationUpdate.never,
                      // );
                    }
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.app',
                  ),
                  // Builder(
                  //   builder: (context) {
                  //     if (MapCamera.of(context).zoom < 13) return SizedBox.shrink();
                  //     return TileLayer();
                  //   },
                  // ),
                ],
              ),
            ),
            SizedBox( // Set a fixed height for the slider
              height: 50,  // Adjust height as needed
              child: Slider(
                value: _currentSliderValue,
                min: 6,
                max: 20,
                divisions: 7,
                label: _currentSliderValue.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    _currentSliderValue = value;
                    _mapController.move(new LatLng(AppData().currentUserPosition.latitude, AppData().currentUserPosition.longitude), _currentSliderValue);
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