// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AgentLocations.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AgentLocationAdapter extends TypeAdapter<AgentLocation> {
  @override
  final int typeId = 21;

  @override
  AgentLocation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AgentLocation(
      longitude: fields[1] as double,
      latitude: fields[2] as double,
      location: fields[3] as String,
    )..no = fields[0] as int?;
  }

  @override
  void write(BinaryWriter writer, AgentLocation obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.no)
      ..writeByte(1)
      ..write(obj.longitude)
      ..writeByte(2)
      ..write(obj.latitude)
      ..writeByte(3)
      ..write(obj.location);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AgentLocationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
