import 'package:hfbbank/screens/dashboard/ATMLocations.dart';
import 'package:hive/hive.dart';

class ATMLocationRepository {
  Future<Box<ATMLocation>> openBox() async {
    if (Hive.isBoxOpen("atmLocations")) {
      return Hive.box<ATMLocation>("atmLocations");
    } else {
      return await Hive.openBox<ATMLocation>("atmLocations");
    }
  }

  insertATMLocations(List<ATMLocation> atmLocations) async {
    var box = await openBox();
    await box.clear();
    box.addAll(atmLocations);
  }

  Future<List<ATMLocation>> getAllATMLocations() async {
    var box = await openBox();
    return box.values.toList();
  }
}