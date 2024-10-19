// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'BranchLocations.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BranchLocsAdapter extends TypeAdapter<BranchLocs> {
  @override
  final int typeId = 23;

  @override
  BranchLocs read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BranchLocs(
      longitude: fields[1] as double,
      latitude: fields[2] as double,
      location: fields[3] as String,
    )..no = fields[0] as int?;
  }

  @override
  void write(BinaryWriter writer, BranchLocs obj) {
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
      other is BranchLocsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
