import 'package:hive_flutter/adapters.dart';

part 'AgentLocations.g.dart';

@HiveType(typeId: 21)
class AgentLocation {
  @HiveField(0)
  int? no;
  @HiveField(1)
  double longitude;
  @HiveField(2)
  double latitude;
  @HiveField(3)
  String location;

  AgentLocation(
      {required this.longitude,
        required this.latitude,
        required this.location});

  AgentLocation.fromJson(Map<String, dynamic> json)
      : longitude = json["Longitude"],
        latitude = json["Latitude"],
        location = json["Location"];
}