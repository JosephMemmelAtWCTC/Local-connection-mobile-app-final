import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../Models/LoggedInUser.dart';
import '../helpers/LocationHelper.dart';

class AppData {
  static final AppData _appData = AppData._internal();

  LoggedInUser loggedInUser = LoggedInUser();
  Position currentUserPosition = Position(
    longitude: 0,
    latitude: 0,
    timestamp: DateTime.now(), // Updated to `DateTime.now()`
    accuracy: 0,
    altitude: 0,
    altitudeAccuracy: 0,
    heading: 0,
    headingAccuracy: 0,
    speed: 0,
    speedAccuracy: 0,
  );

  LatLng get currentLatLong => LatLng(currentUserPosition.latitude, currentUserPosition.longitude);

  Future<Position> updateUserLocation() async {
    currentUserPosition = await determinePosition();
    return currentUserPosition;
  }

  factory AppData() {
    return _appData;
  }
  AppData._internal();
}

final appData = AppData();
