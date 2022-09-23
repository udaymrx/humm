// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

part 'music_model.g.dart';

List<MusicModel> musicFromJson(dynamic jsonRes) =>
    List<MusicModel>.from(jsonRes.map((x) => MusicModel.fromJson(x)));

String musicToJson(List<MusicModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@HiveType(typeId: 5)
class MusicModel {
  const MusicModel({
    required this.id,
    required this.data,
    this.uri,
    required this.displayName,
    required this.displayNameWOExt,
    this.album,
    this.albumId,
    this.artist,
    this.artistId,
    this.duration,
    required this.title,
    required this.fileExtension,
    this.isFavorite = false,
  });

  @HiveField(0)
  final int id;

  @HiveField(1)
  final String? uri;

  @HiveField(2)
  final String displayName;

  @HiveField(3)
  final String displayNameWOExt;

  @HiveField(4)
  final String? album;

  @HiveField(5)
  final int? albumId;

  @HiveField(6)
  final String? artist;

  @HiveField(7)
  final int? artistId;

  @HiveField(8)
  final int? duration;

  @HiveField(9)
  final String title;

  @HiveField(10)
  final String fileExtension;

  @HiveField(11)
  final bool isFavorite;

  @HiveField(12)
  final String data;

  MusicModel copyWith({
    int? id,
    String? data,
    String? uri,
    String? displayName,
    String? displayNameWOExt,
    String? album,
    int? albumId,
    String? artist,
    int? artistId,
    int? duration,
    String? title,
    String? fileExtension,
    bool? isFavorite,
  }) {
    return MusicModel(
      id: id ?? this.id,
      data: data ?? this.data,
      uri: uri ?? this.uri,
      displayName: displayName ?? this.displayName,
      displayNameWOExt: displayNameWOExt ?? this.displayNameWOExt,
      album: album ?? this.album,
      albumId: albumId ?? this.albumId,
      artist: artist ?? this.artist,
      artistId: artistId ?? this.artistId,
      duration: duration ?? this.duration,
      title: title ?? this.title,
      fileExtension: fileExtension ?? this.fileExtension,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      '_data': data,
      '_uri': uri,
      '_display_name': displayName,
      '_display_name_wo_ext': displayNameWOExt,
      'album': album,
      'album_id': albumId,
      'artist': artist,
      'artist_id': artistId,
      'duration': duration,
      'title': title,
      'file_extension': fileExtension,
      'isFavorite': isFavorite,
    };
  }

  String toJson() => json.encode(toMap());

  factory MusicModel.fromJson(Map<String, dynamic> json) => MusicModel(
        id: json["_id"],
        displayName: json["_display_name"],
        data: json["_data"],
        displayNameWOExt: json["_display_name_wo_ext"],
        title: json["title"],
        album: json["album"],
        albumId: json["album_id"],
        artist:
            json["artist"] == "<unknown>" ? "Unknown Artist" : json["artist"],
        artistId: json["artist_id"],
        duration: json["duration"],
        uri: json["_uri"],
        fileExtension: json["file_extension"],
        isFavorite: json["isFavorite"] ?? false,
      );

  @override
  String toString() {
    return 'MusicModel(id: $id, data: $data, uri: $uri, displayName: $displayName, displayNameWOExt: $displayNameWOExt, album: $album, albumId: $albumId, artist: $artist, artistId: $artistId, duration: $duration, title: $title, fileExtension: $fileExtension, isFavorite: $isFavorite)';
  }

  @override
  bool operator ==(covariant MusicModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.uri == uri &&
        other.data == data &&
        other.displayName == displayName &&
        other.displayNameWOExt == displayNameWOExt &&
        other.album == album &&
        other.albumId == albumId &&
        other.artist == artist &&
        other.artistId == artistId &&
        other.duration == duration &&
        other.title == title &&
        other.fileExtension == fileExtension &&
        other.isFavorite == isFavorite;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        uri.hashCode ^
        data.hashCode ^
        displayName.hashCode ^
        displayNameWOExt.hashCode ^
        album.hashCode ^
        albumId.hashCode ^
        artist.hashCode ^
        artistId.hashCode ^
        duration.hashCode ^
        title.hashCode ^
        fileExtension.hashCode ^
        isFavorite.hashCode;
  }
}
