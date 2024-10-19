
import 'package:hive/hive.dart';

import 'BranchLocations.dart';

class BranchAdapter extends TypeAdapter<BranchLocs> {
  @override
  final int typeId = 0; // Unique identifier for your Article class

  @override
  BranchLocs read(BinaryReader reader) {
    return BranchLocs(
      longitude: reader.readDouble(),
      latitude: reader.readDouble(),
      location: '',
    );
  }

  @override
  void write(BinaryWriter writer, BranchLocs obj) {
    writer.writeDouble(obj.longitude);
    writer.writeDouble(obj.latitude);
    writer.writeString(obj.location);
  }
}