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
      volume: fields[2] == null ? 100.0 : (fields[2] as num).toDouble(),
    );
  }

  @override
  void write(BinaryWriter writer, SerializedMedia obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.uri)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.volume);
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

class PlaylistModeAdapter extends TypeAdapter<PlaylistMode> {
  @override
  final typeId = 1;

  @override
  PlaylistMode read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PlaylistMode.none;
      case 1:
        return PlaylistMode.single;
      case 2:
        return PlaylistMode.loop;
      default:
        return PlaylistMode.none;
    }
  }

  @override
  void write(BinaryWriter writer, PlaylistMode obj) {
    switch (obj) {
      case PlaylistMode.none:
        writer.writeByte(0);
      case PlaylistMode.single:
        writer.writeByte(1);
      case PlaylistMode.loop:
        writer.writeByte(2);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlaylistModeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
