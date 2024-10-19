import 'package:hive/hive.dart';

import 'BranchLocations.dart';

class BranchLocationRepository {
  Future<Box<BranchLocs>> openBox() async {
    if (Hive.isBoxOpen("branchLocations")) {
      return Hive.box<BranchLocs>("branchLocations");
    } else {
      return await Hive.openBox<BranchLocs>("branchLocations");
    }
  }

  insertBranchLocations(List<BranchLocs> branchLocations) async {
    var box = await openBox();
    await box.clear();
    box.addAll(branchLocations);
  }

  Future<List<BranchLocs>> getAllBranchLocations() async {
    var box = await openBox();
    return box.values.toList();
  }
}