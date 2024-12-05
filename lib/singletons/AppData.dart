import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:local_connection_first/Models/LocalLocation.dart';

import '../Models/LoggedInUser.dart';
import '../helpers/LocationHelper.dart';
import '../helpers/NetworkRequestsHelper.dart';

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

  Future<List<LocalLocation>> get currentLocalLocations async {
    print("INSIDE BEFORE");
    final response = await NetworkRequestsHelper.getData(
      "https://localconnectionsapi.azurewebsites.net/localLocations/all",
    );
    print("INSIDE AFTER");
    // [{id: 1, locationNickname: Location Nickname, creatorId: CreatorID, description: Description, latitude: 0, longitude: 0, createdOn: 2024-12-04T05:55:48.336}]
    // const List<LocalLocation> localLocations = [];
    // localLocations.add(response as LocalLocation);
    print("INSIDE AFTER2 response.body = ${jsonDecode(response.body)}");

    // List<LocalLocation> listLocalLocations = (jsonDecode(response.body)).map((item) => LocalLocation.fromJson(item)).toList();
    List<LocalLocation> listLocalLocations = (jsonDecode(response.body) as List<dynamic>).map((item) => LocalLocation.fromJson(item as Map<String, dynamic>)).toList();

    return listLocalLocations;
  }


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
