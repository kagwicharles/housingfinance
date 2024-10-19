import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hfbbank/screens/dashboard/BranchLocationRepository.dart' as hfbRep;
import 'package:hfbbank/screens/home/components/extensions.dart';
import 'package:hive/hive.dart';

import '../../theme/theme.dart';
import 'ATMLocationRepository.dart';
import 'ATMLocations.dart';
import 'AgentLocationRepository.dart';
import 'AgentLocations.dart';
import 'BranchLocations.dart';


class MapView extends StatefulWidget {
  String type;

  MapView({
    required this.type
  });

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  late GoogleMapController mapController;
  final _atmLocationRepository = ATMLocationRepository();
  final _agentLocationRepository = AgentLocationRepository();
  final _branchLocationRepository = hfbRep.BranchLocationRepository();
  final LatLng _center = const LatLng(0.3476, 32.5825);
  final Set<Marker> _markers = {};
  List<AgentLocation> _agentLocations = [];
  List<BranchLocs> _branchLocations = [];
  List<ATMLocation> _atmLocations = [];
  List<AppLocation> _appLocations = [];
  int counter = 1;
  bool querySuccess = false;


  Future<List<AppLocation>> _getLocations() async {
    _appLocations.clear();
    if (widget.type == 'AGENT') {
      debugPrint("Getting agent locations...");
      _agentLocations = await _agentLocationRepository.getAllAgentLocations();
      for (var agentLocations in _agentLocations) {
        _appLocations.add(AppLocation(
            longitude: agentLocations.longitude,
            latitude: agentLocations.latitude,
            location: agentLocations.location));
      }
      debugPrint("Agents...$_appLocations");
    } else if (widget.type == 'ATM'){
      debugPrint("Getting ATMlocations...");
      _atmLocations =
          await _atmLocationRepository.getAllATMLocations();
      for (var atmLocation in _atmLocations) {
        _appLocations.add(AppLocation(
            longitude: atmLocation.longitude,
            latitude: atmLocation.latitude,
            location: atmLocation.location));
      }
      debugPrint("Branches...$_appLocations");
    } else {
    debugPrint("branch locations...");
    _branchLocations =
    await _branchLocationRepository.getAllBranchLocations();
    for (var branchLocation in _branchLocations) {
    _appLocations.add(AppLocation(
    longitude: branchLocation.longitude,
    latitude: branchLocation.latitude,
    location: branchLocation.location));
    }
    debugPrint("Branches...$_appLocations");
    }
    return _appLocations;
  }

  updateMarkers() async {
    EasyLoading.show(status: "Processing");
    await _getLocations();
    setState(() {
      _markers.clear();
      for (var location in _appLocations) {
        _markers.add(Marker(
          markerId: MarkerId(location.location),
          position: LatLng(location.latitude, location.longitude),
          infoWindow: InfoWindow(
            title: location.location,
          ),
        ));
        Future.delayed(const Duration(milliseconds: 500), () {
          EasyLoading.dismiss();
        });
      }
    });

    counter++;
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    updateMarkers();

    // Calculate the nearest location
    Position currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );

    AppLocation nearestLocation = findNearestLocation(currentPosition, _appLocations);

    // Set the camera position to the nearest location
    controller.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(nearestLocation.latitude, nearestLocation.longitude),
        15.0, // Adjust the zoom level as needed
      ),
    );
  }


  AppLocation findNearestLocation(Position userLocation, List<AppLocation> locations) {
    double minDistance = double.infinity;
    AppLocation nearestLocation = locations[0];

    for (var location in locations) {
      double distance = Geolocator.distanceBetween(
        userLocation.latitude,
        userLocation.longitude,
        location.latitude,
        location.longitude,
      );

      if (distance < minDistance) {
        minDistance = distance;
        nearestLocation = location;
      }
    }

    return nearestLocation;
  }



  @override
  void initState() {
    super.initState();
    _appLocations.clear();

    switch (widget.type){
      case "AGENT":
        fetchAgentsData();
        break;
      case "BRANCH":
        fetchBranchesData();
        break;
      case "ATM":
        fetchATMsData();
        break;
    }
  }

  Future<void> fetchAgentsData() async {
    final box = await Hive.openBox<AgentLocation>('agentLocations');

    if (box.isEmpty) {
      final _api_service = APIService();
      _api_service.getAgentLocations().then((value){
        if (value.status == StatusCode.success.statusCode){
          List<AgentLocation> agentLocations = [];

          if(value.dynamicList != null){
            for (var item in value.dynamicList!) {
              double? latitude = item['Latitude'];
              double? longitude = item['Longitude'];
              String? name = item['Name'];

              if (latitude != null && longitude != null && name != null) {
                agentLocations.add(AgentLocation(
                  latitude: latitude,
                  longitude: longitude,
                  location: name,
                ));
              }
            }
            _agentLocationRepository.insertAgentLocations(agentLocations);

            setState(() {
              querySuccess = true;
            });
          }
        }
      }
      );
    }else{
      setState(() {
        querySuccess = true;
      });
    }
  }

  Future<void> fetchATMsData() async {
    final box = await Hive.openBox<ATMLocation>('atmLocations');

    if (box.isEmpty) {
      final _api_service = APIService();
      _api_service.getATMLocations().then((value){
        if (value.status == StatusCode.success.statusCode){
          List<ATMLocation> atmLocations = [];

          if(value.dynamicList != null){
            for (var item in value.dynamicList!) {
              double? latitude = item['Latitude'];
              double? longitude = item['Longitude'];
              String? name = item['Location'];

              if (latitude != null && longitude != null && name != null) {
                atmLocations.add(ATMLocation(
                  latitude: latitude,
                  longitude: longitude,
                  location: name,
                ));
              }
            }
            _atmLocationRepository.insertATMLocations(atmLocations);

            setState(() {
              querySuccess = true;
            });
          }
        }
      }
      );
    }else{
      setState(() {
        querySuccess = true;
      });
    }
  }

  Future<void> fetchBranchesData() async {
    final box = await Hive.openBox<BranchLocs>('branchLocations');

    if (box.isEmpty) {
      final _api_service = APIService();
      _api_service.getBranchLocations().then((value){
        if (value.status == StatusCode.success.statusCode){
          List<BranchLocs> branchLocations = [];

          if(value.dynamicList != null){
            for (var item in value.dynamicList!) {
              double? latitude = item['Latitude'];
              double? longitude = item['Longitude'];
              String? name = item['Location'];

              if (latitude != null && longitude != null && name != null) {
                branchLocations.add(BranchLocs(
                  latitude: latitude,
                  longitude: longitude,
                  location: name,
                ));
              }
            }
            _branchLocationRepository.insertBranchLocations(branchLocations);

            setState(() {
              querySuccess = true;
            });
          }
        }
      }
      );
    }else{
      setState(() {
        querySuccess = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          margin: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
          child: querySuccess ?
          Stack(
            alignment: Alignment.center,
            fit: StackFit.expand,
            children: [
              GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 7.0,
                ),
                markers: _markers,
              ),
              Positioned(
                  top: 24,
                  right: 15,
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: APIService.appPrimaryColor,
                    ),
                    child: Text(
                      // widget.isAgents ? "Agents" : "Branches \n & \n ATMs",
                      "${widget.type.capitalizeFirstLetter()} Locations",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontFamily: "Manrope",),
                      textAlign: TextAlign.center,
                    ),
                  ))
            ],
          ) :
      const SpinKitSpinningLines(color: primaryColor, duration: Duration(milliseconds: 2000), size: 30,)),
    );
  }
}
