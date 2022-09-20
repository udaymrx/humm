// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlist_info_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlaylistInfoModelAdapter extends TypeAdapter<PlaylistInfoModel> {
  @override
  final int typeId = 6;

  @override
  PlaylistInfoModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlaylistInfoModel(
      playlistName: fields[0] as String,
      noOfSongs: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, PlaylistInfoModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.playlistName)
      ..writeByte(1)
      ..write(obj.noOfSongs);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlaylistInfoModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
