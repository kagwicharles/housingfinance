import 'package:hive_flutter/adapters.dart';

part 'BranchLocations.g.dart';

@HiveType(typeId: 23)
class BranchLocs {
  @HiveField(0)
  int? no;
  @HiveField(1)
  double longitude;
  @HiveField(2)
  double latitude;
  @HiveField(3)
  String location;

  BranchLocs(
      {required this.longitude,
        required this.latitude,
        required this.location});

  BranchLocs.fromJson(Map<String, dynamic> json)
      : longitude = json["Longitude"],
        latitude = json["Latitude"],
        location = json["Location"];
}