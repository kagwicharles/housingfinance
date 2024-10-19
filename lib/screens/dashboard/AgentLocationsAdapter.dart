import 'package:hive/hive.dart';

import 'AgentLocations.dart';

class AgentsAdapter extends TypeAdapter<AgentLocation> {
  @override
  final int typeId = 0; // Unique identifier for your Article class

  @override
  AgentLocation read(BinaryReader reader) {
    return AgentLocation(
      longitude: reader.readDouble(),
      latitude: reader.readDouble(),
      location: '',
    );
  }

  @override
  void write(BinaryWriter writer, AgentLocation obj) {
    writer.writeDouble(obj.longitude);
    writer.writeDouble(obj.latitude);
    writer.writeString(obj.location);
  }
}
