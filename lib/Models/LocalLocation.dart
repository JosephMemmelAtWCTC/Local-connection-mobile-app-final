class LocalLocation {
  int id;
  String locationNickname;
  String creatorId;
  String description;
  double latitude;
  double longitude;
  DateTime createdOn;

  LocalLocation({
    required this.id,
    required this.locationNickname,
    required this.creatorId,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.createdOn,
  });

  factory LocalLocation.fromJson(Map<String, dynamic> json) {
    return LocalLocation(
      id: json['id'] as int,
      locationNickname: json['locationNickname'] as String,
      creatorId: json['creatorId'] as String,
      description: json['description'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      createdOn: DateTime.parse(json['createdOn'] as String),
    );
  }

}