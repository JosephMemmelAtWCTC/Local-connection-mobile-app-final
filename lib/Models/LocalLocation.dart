class LocalLocation {
  int id;
  bool enabled;
  String locationNickname;
  String creatorId;
  String description;
  double latitude;
  double longitude;
  DateTime createdOn;
  DateTime? dateStart;
  DateTime? dateEnd;
  List<String> localLabelStrings = [];

  LocalLocation({
    required this.id,
    required this.enabled,
    required this.locationNickname,
    required this.creatorId,
    required this.description,
    required this.latitude,
    required this.longitude,
    this.dateStart,
    this.dateEnd,
    required this.createdOn,
    required this.localLabelStrings,
  });

  factory LocalLocation.fromJson(Map<String, dynamic> json) {
    return LocalLocation(
      id: json['id'] as int,
      enabled: json['enabled'] as bool,
      locationNickname: json['locationNickname'] as String,
      creatorId: json['creatorId'] as String,
      description: json['description'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      dateStart: DateTime.tryParse(json['dateStart'] as String),
      dateEnd: DateTime.tryParse(json['dateEnd'] as String),
      createdOn: DateTime.parse(json['createdOn'] as String),
      localLabelStrings: (json['localLabelStrings'] as List).cast<String>() ?? [],
    );
  }

}