import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:local_connection_first/helpers/NetworkRequestsHelper.dart';
// import 'package:url_launcher/url_launcher.dart';
import 'package:local_connection_first/singletons/AppData.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

import 'Models/LocalLocation.dart';
import 'Models/LocationLabel.dart';

class ManagePage extends StatefulWidget {
  const ManagePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<ManagePage> createState() => _ManagePageState();
}

class _ManagePageState extends State<ManagePage> {

  final MapController _mapController = MapController();

  final _formKey = GlobalKey<FormState>(); // Key for form validation
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  List<String> _selectedTags = [];

  void _handleRadioTap(int? index) {
    if (index != null) {
      setState(() {
        _radioGroupValue = index;
      });
    }
  }

  // [User Input States]
  final List<bool> _enabled = [false, true];  // List<bool> _selections = List.generate(2, (_) => false);

  LocalLocation _localLocation = new LocalLocation(
    id: 0,
    enabled: false,
    locationNickname: "Test",
    creatorId: "test",
    description: "Test2",
    latitude: 0.0,
    longitude: 0.0,
    createdOn: DateTime.now(),
    localLabelStrings: [],
  );

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
  int _radioGroupValue = 0;

  void changeRadioValue(int? value) {
    _radioGroupValue = value!;
    setState(() {});
  }

  Future<void> _moveMapToCurrentLocation() async {
    _mapController.move(LatLng(AppData().currentUserPosition.latitude, AppData().currentUserPosition.longitude), 16);
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
        // Here we take the value from the ManagePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              // flex: 2,
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: LatLng(AppData().currentUserPosition.latitude, AppData().currentUserPosition.longitude)?? const LatLng(0,0),
                  initialZoom: 16,
                  interactionOptions: const InteractionOptions(
                    enableMultiFingerGestureRace: false,
                    flags: InteractiveFlag.none
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
                        child: Icon(Icons.location_history, size: 24.0),
                      ),
                    ],
                  ),
                  if(AppData().loggedInUser.isLoggedIn) Positioned(
                    top: 16.0,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: Theme.of(context).colorScheme.primaryFixed,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.secondary,
                            width: 2.0,
                          ),
                        ),
                        child: Text(
                          "You can only use your current position as the location",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Flexible(
            Container(
              // flex: 3,
              child:
              !AppData().loggedInUser.isLoggedIn ? const Text("You must be logged in to post") : Container(
                width: double.infinity,
                height: 420,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.secondary,
                    width: 3.0,
                  ),
                ),
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          labelText: "Title",
                          hintText: "Enter a title",
                          counterText: "${_titleController.text.length}/50",
                        ),
                        maxLength: 50,
                        onChanged: (value) {
                          setState(() {});
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a title';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: "Description",
                          hintText: "Enter a description",
                          counterText: "${_descriptionController.text.length}/200",
                        ),
                        maxLength: 200,
                        onChanged: (value) {
                          setState(() {});
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a description';
                          }
                          return null;
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Start Date"),
                          TextButton(
                            onPressed: () async {
                              final newDate = await showDatePicker(
                                context: context,
                                firstDate: DateTime.now(),
                                lastDate: DateTime(DateTime.now().year+1, DateTime.now().month, DateTime.now().day),
                                initialDate: _localLocation.dateStart,
                              );
                              if(newDate != null){
                                _localLocation.dateStart = newDate;
                                setState(() {});
                              }
                            },
                            child: Text(
                              _localLocation.dateStart != null ? '${_localLocation.dateStart!.month}/${_localLocation.dateStart!.day}/${_localLocation.dateStart!.year}' : 'mm/dd/yy',
                            ),
                          ),
                          const Text("End Date"),
                          TextButton(
                            onPressed: () async {
                              final newDate = await showDatePicker(
                                context: context,
                                firstDate: _localLocation.dateStart ?? DateTime.now(),
                                lastDate: DateTime(DateTime.now().year+1, DateTime.now().month, DateTime.now().day),
                                initialDate: _localLocation.dateEnd,
                              );
                              if(newDate != null){
                                _localLocation.dateEnd = newDate;
                                setState(() {});
                              }
                            },
                            child: Text(
                              _localLocation.dateEnd != null ? '${_localLocation.dateEnd!.month}/${_localLocation.dateEnd!.day}/${_localLocation.dateEnd!.year}' : 'mm/dd/yy',
                            ),
                          ),
                        ],
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: <Widget>[
                      //     new Radio(
                      //       value: 0,
                      //       groupValue: _radioGroupValue,
                      //       onChanged: changeRadioValue,
                      //     ),
                      //     new Text(
                      //       'Garage Sale',
                      //       style: new TextStyle(fontSize: 16.0),
                      //     ),
                      //
                      //
                      //
                      //
                      //   ],
                      // ),
                      SingleChildScrollView(
                        child: GridView.count(
                          shrinkWrap: true, // Wrap the GridView with SingleChildScrollView
                          crossAxisCount: 2,
                          childAspectRatio: 4.0,
                          children: List.generate(LocationLabel.values.length, (index) {
                            final locationLabel = LocationLabel.values[index];
                            return GestureDetector(
                              onTap: () {
                                print("______ ${index}");
                                setState(() {
                                  _radioGroupValue = index;
                                });
                              },
                              child: LocationLabelCheckbox(
                                radioGroupValue: _radioGroupValue,
                                radioIndex: index,
                                locationLabel: locationLabel,
                                onTap: _handleRadioTap,
                              ),
                            );
                          }),
                        ),
                      ),
                      TextButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(Theme.of(context).colorScheme.primaryFixedDim),
                          padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0)),
                        ),
                        onPressed: () async {

                          if(_localLocation.dateStart != null && _localLocation.dateEnd != null){
                            Response response = await NetworkRequestsHelper.postData("https://localconnectionsapi.azurewebsites.net/localLocations", bodyJson: {
                              "id": 0,
                              "enabled": true,
                              "locationNickname": _titleController.text,
                              "creatorId": AppData().loggedInUser.username ?? "_____",
                              "description": _descriptionController.text,
                              "latitude": AppData().currentUserPosition.latitude,
                              "longitude": AppData().currentUserPosition.longitude,
                              "createdOn": DateTime.now().toIso8601String(),
                              "dateStart": _localLocation.dateStart?.toIso8601String(),
                              "dateEnd": _localLocation.dateEnd?.toIso8601String(),
                              "localLabelStrings": [LocationLabel.toEnum(_radioGroupValue.toString()).title]
                            });
                            if(response.statusCode == 201){
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                  Text('Posted your event! :).'),
                                ),
                              );
                              _titleController.text = "";
                              _descriptionController.text = "";
                              _radioGroupValue = 0;
                              _localLocation = new LocalLocation(
                                id: 0,
                                enabled: false,
                                locationNickname: "Test",
                                creatorId: "test",
                                description: "Test2",
                                latitude: 0.0,
                                longitude: 0.0,
                                createdOn: DateTime.now(),
                                localLabelStrings: [],
                              );
                              setState(() {

                              });
                            }else{
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                  Text('Failed Network Response'),
                                ),
                              );
                            }
                          }else{
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                Text('Start date or end date cannot be empty.'),
                              ),
                            );
                          }
                          // final responseData = jsonDecode(response.body);

                          // print("responseData for post location = ${jsonDecode(responseData)}");

                        },
                        child: const Text("Save"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class LocationLabelCheckbox extends StatefulWidget {
  final LocationLabel locationLabel;
  int radioGroupValue;
  int radioIndex;
  final void Function(int) onTap;
  // bool isChecked; //Key to allow _isChecked state for _LocationLabelCheckboxState

  LocationLabelCheckbox({
    super.key,
    required this.locationLabel,
    required this.radioGroupValue,
    required this.radioIndex,
    required this.onTap,
    // required this.isChecked,
  });

  @override
  State<LocationLabelCheckbox> createState() => _LocationLabelCheckboxState();
}

class _LocationLabelCheckboxState extends State<LocationLabelCheckbox> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap(widget.radioIndex);
        // setState(() {
        //   widget.radioGroupValue = widget.radioIndex;
        // });
      },
      child: Row(
        children: [
          Radio(
            groupValue: widget.radioGroupValue,
            value: widget.radioIndex,
            onChanged: (int? newValue) {
              if (newValue != null && widget.radioIndex == newValue) {
                setState(() {
                  widget.onTap(widget.radioIndex);
                });
              }
            }
          ),
          const SizedBox(width: 8.0),
          Icon(widget.locationLabel.icon, color: Theme.of(context).colorScheme.secondary),
          const SizedBox(width: 8.0),
          Text(widget.locationLabel.title, selectionColor: Theme.of(context).colorScheme.secondary),
        ],
      ),
    );
  }
}