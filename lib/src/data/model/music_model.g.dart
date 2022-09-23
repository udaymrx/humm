// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'music_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MusicModelAdapter extends TypeAdapter<MusicModel> {
  @override
  final int typeId = 5;

  @override
  MusicModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MusicModel(
      id: fields[0] as int,
      data: fields[12] as String,
      uri: fields[1] as String?,
      displayName: fields[2] as String,
      displayNameWOExt: fields[3] as String,
      album: fields[4] as String?,
      albumId: fields[5] as int?,
      artist: fields[6] as String?,
      artistId: fields[7] as int?,
      duration: fields[8] as int?,
      title: fields[9] as String,
      fileExtension: fields[10] as String,
      isFavorite: fields[11] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, MusicModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.uri)
      ..writeByte(2)
      ..write(obj.displayName)
      ..writeByte(3)
      ..write(obj.displayNameWOExt)
      ..writeByte(4)
      ..write(obj.album)
      ..writeByte(5)
      ..write(obj.albumId)
      ..writeByte(6)
      ..write(obj.artist)
      ..writeByte(7)
      ..write(obj.artistId)
      ..writeByte(8)
      ..write(obj.duration)
      ..writeByte(9)
      ..write(obj.title)
      ..writeByte(10)
      ..write(obj.fileExtension)
      ..writeByte(11)
      ..write(obj.isFavorite)
      ..writeByte(12)
      ..write(obj.data);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MusicModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
