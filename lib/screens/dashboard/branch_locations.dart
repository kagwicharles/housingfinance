import 'dart:async';

import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hfbbank/theme/theme.dart';

class BranchLocations extends StatefulWidget {
  const BranchLocations({super.key});

  @override
  State<BranchLocations> createState() => _BranchLocationsState();
}

class _BranchLocationsState extends State<BranchLocations> {
  final _atmLocationRepository = AtmLocationRepository();
  final _branchLocationRepository = BranchLocationRepository();
  Set<Marker> items = Set();
  List<BranchLocation> branches = [];

  getBranchLocations() async {
    await _branchLocationRepository.getAllBranchLocations().then((value) {
      debugPrint('Branches>>$value');
      for (var branch in value) {
        branches.add(branch);
        debugPrint('Branches>>${branches.length}');
      }
    });
  }

  Completer<GoogleMapController> _controller = Completer();

  _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  _createMarkers() async {
    await getBranchLocations();
    branches.forEach((element) {
      items.add(Marker(
          markerId: MarkerId(element.location),
          position: LatLng(element.latitude, element.longitude)));
    });
    setState(() {});
  }

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(0.3152, 32.5816),
    zoom: 7,
  );

  @override
  void initState() {
    _createMarkers();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: GoogleMap(
        mapType: MapType.normal,
        markers: items,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}

class ATMS extends StatefulWidget {
  const ATMS({super.key});

  @override
  State<ATMS> createState() => _ATMSState();
}

class _ATMSState extends State<ATMS> {
  final _atmLocationRepository = AtmLocationRepository();
  final _branchLocationRepository = BranchLocationRepository();
  Set<Marker> items = Set();
  List<AtmLocation> branches = [];

  getBranchLocations() async {
    await _atmLocationRepository.getAllAtmLocations().then((value) {
      debugPrint('Branches>>$value');
      for (var branch in value) {
        branches.add(branch);
        debugPrint('Branches>>${branches.length}');
      }
    });
  }

  Completer<GoogleMapController> _controller = Completer();

  _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  _createMarkers() async {
    await getBranchLocations();
    branches.forEach((element) {
      items.add(Marker(
          markerId: MarkerId(element.location),
          position: LatLng(element.latitude, element.longitude)));
    });
    setState(() {});
  }

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(0.3152, 32.5816),
    zoom: 7,
  );

  @override
  void initState() {
    _createMarkers();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: GoogleMap(
        mapType: MapType.normal,
        markers: items,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}



class Locations extends StatefulWidget {
  Locations({Key? key}) : super(key: key);

  @override
  _LocationsState createState() => _LocationsState();
}

class _LocationsState extends State<Locations> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Locations'),
      ),
      body: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: <Widget>[
              ButtonsTabBar(
                // backgroundColor: primaryLightVariant,
                unselectedBackgroundColor: Colors.grey[300],
                unselectedLabelStyle: TextStyle(color: Colors.black),
                labelStyle:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                tabs: [
                  Tab(
                    // icon: Icon(Icons.house_outlined),
                    text: "Branches",
                  ),
                  Tab(
                    // icon: Icon(Icons.atm_outlined),
                    text: "ATMs",
                  )
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: <Widget>[
                    BranchLocations(),
                    ATMS(),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
