
import 'package:hive/hive.dart';

import 'ATMLocations.dart';

class ATMAdapter extends TypeAdapter<ATMLocation> {
  @override
  final int typeId = 0; // Unique identifier for your Article class

  @override
  ATMLocation read(BinaryReader reader) {
    return ATMLocation(
      longitude: reader.readDouble(),
      latitude: reader.readDouble(),
      location: '',
    );
  }

  @override
  void write(BinaryWriter writer, ATMLocation obj) {
    writer.writeDouble(obj.longitude);
    writer.writeDouble(obj.latitude);
    writer.writeString(obj.location);
  }
}