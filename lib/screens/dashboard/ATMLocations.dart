import 'package:hive_flutter/adapters.dart';

part 'ATMLocations.g.dart';

@HiveType(typeId: 22)
class ATMLocation {
  @HiveField(0)
  int? no;
  @HiveField(1)
  double longitude;
  @HiveField(2)
  double latitude;
  @HiveField(3)
  String location;

  ATMLocation(
      {required this.longitude,
        required this.latitude,
        required this.location});

  ATMLocation.fromJson(Map<String, dynamic> json)
      : longitude = json["Longitude"],
        latitude = json["Latitude"],
        location = json["Location"];
}