import 'package:flutter/material.dart';

enum LocationLabel {
  other(id: 0, title: "Other", description: "Other or error", icon: Icons.share_location),
  garage(id: 1, title: "Garage Sale", description: "It's a Garage Sale", icon: Icons.other_houses),//warehouse
  estate(id: 2, title: "Estate Sale", description: "It's a Estate Sale", icon: Icons.house),
  eggs(id: 3, title: "Fresh Eggs", description: "Check the egg variant", icon: Icons.egg),
  plants(id: 4, title: "Live Plants", description: "Flowers and alike", icon: Icons.local_florist),
  honey(id: 4, title: "Fresh Honey", description: "Flowers and alike", icon: Icons.hive);


  const LocationLabel({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
  });

  final int id;
  final String title;
  final String description;
  final IconData icon;

  static toEnum(String name){
    for(LocationLabel localLabelEnum in LocationLabel.values){
      if(localLabelEnum.id.toString() == name || localLabelEnum.title == name){
        return localLabelEnum;
      }
    }
    return other;
  }


}