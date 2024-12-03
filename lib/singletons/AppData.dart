import 'package:geolocator/geolocator.dart';

import '../Models/LoggedInUser.dart';
import '../helpers/LocationHelper.dart';

class AppData {
  static final AppData _appData = new AppData._internal();

  LoggedInUser loggedInUser = new LoggedInUser();
  Position currentUserPosition = new Position(longitude: 0, latitude: 0, timestamp: DateTime.timestamp(), accuracy: 0, altitude: 0, altitudeAccuracy: 0, heading: 0, headingAccuracy: 0, speed: 0, speedAccuracy: 0);


  Future<Position> updateUserLocation() async {
    currentUserPosition = await determinePosition();
    return currentUserPosition;
  }


  factory AppData() {
    return _appData;
  }
  AppData._internal();
}final appData = AppData();