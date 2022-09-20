import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

part 'playlist_info_model.g.dart';

@HiveType(typeId: 6)
class PlaylistInfoModel {
  @HiveField(0)
  final String playlistName;
  @HiveField(1)
  final int noOfSongs;
  PlaylistInfoModel({
    required this.playlistName,
    required this.noOfSongs,
  });

  PlaylistInfoModel copyWith({
    String? playlistName,
    int? noOfSongs,
  }) {
    return PlaylistInfoModel(
      playlistName: playlistName ?? this.playlistName,
      noOfSongs: noOfSongs ?? this.noOfSongs,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'playlistName': playlistName,
      'noOfSongs': noOfSongs,
    };
  }

  String toJson() => json.encode(toMap());

  factory PlaylistInfoModel.fromJson(Map<String, dynamic> json) =>
      PlaylistInfoModel(
        playlistName: json["playlistName"],
        noOfSongs: json["noOfSongs"],
      );

  @override
  String toString() =>
      'PlaylistInfoModel(playlistName: $playlistName, noOfSongs: $noOfSongs)';

  @override
  bool operator ==(covariant PlaylistInfoModel other) {
    if (identical(this, other)) return true;

    return other.playlistName == playlistName && other.noOfSongs == noOfSongs;
  }

  @override
  int get hashCode => playlistName.hashCode ^ noOfSongs.hashCode;
}
