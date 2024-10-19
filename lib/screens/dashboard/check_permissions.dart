import 'package:geolocator/geolocator.dart';

Future<void> checkLocationPermissions() async {
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Handle the case when the user denies the permission.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Handle the case when the user permanently denies the permission.
    return Future.error('Location permissions are permanently denied');
  }
}
