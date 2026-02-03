// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_adapters.dart';

// **************************************************************************
// AdaptersGenerator
// **************************************************************************

class SerializedMediaAdapter extends TypeAdapter<SerializedMedia> {
  @override
  final typeId = 0;

  @override
  SerializedMedia read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SerializedMedia(
      uri: fields[0] as String,
      title: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SerializedMedia obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.uri)
      ..writeByte(1)
      ..write(obj.title);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SerializedMediaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
