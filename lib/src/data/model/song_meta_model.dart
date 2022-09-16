// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AudioMetadata {
  final String title;
  final String artist;
  final int id;

  AudioMetadata({
    required this.title,
    required this.artist,
    required this.id,
  });

  AudioMetadata copyWith({
    String? title,
    String? artist,
    int? id,
  }) {
    return AudioMetadata(
      title: title ?? this.title,
      artist: artist ?? this.artist,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'artist': artist,
      'id': id,
    };
  }

  String toJson() => json.encode(toMap());

  // factory AudioMetadata.fromJson(String source) => AudioMetadata.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'AudioMetadata(title: $title, artist: $artist, id: $id)';

  @override
  bool operator ==(covariant AudioMetadata other) {
    if (identical(this, other)) return true;
  
    return 
      other.title == title &&
      other.artist == artist &&
      other.id == id;
  }

  @override
  int get hashCode => title.hashCode ^ artist.hashCode ^ id.hashCode;
}
