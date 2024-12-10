import 'package:flutter/material.dart';

enum LocationLabel {
  garage(title: "Garage Sale", description: "It's a Garage Sale", icon: Icons.other_houses),//warehouse
  estate(title: "Estate Sale", description: "It's a Estate Sale", icon: Icons.house),
  other(title: "Other", description: "Other or error", icon: Icons.share_location);

  const LocationLabel({
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final IconData icon;

  nameToEnum(String name){
    for(LocationLabel localLabelEnum in LocationLabel.values){
      if(localLabelEnum.title == "name"){
        return localLabelEnum;
      }
    }

  }

}