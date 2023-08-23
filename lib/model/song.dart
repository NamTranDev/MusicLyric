import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Song {
  String? id;
  String? nameOfSong;
  String? artist;
  String? fileName;
  String? lyric;
  String? duration;
  String? link;
  String? path;
  Song({
    required this.id,
    this.nameOfSong,
    this.artist,
    this.fileName,
    this.lyric,
    this.duration,
    this.link,
    this.path,
  });

  static const FILE_NAME = 'fileName';
  static const LINK = 'link';
  static const PATH = 'path';
  static const LYRIC = 'lyric';

  Song copyWith({
    String? id,
    String? nameOfSong,
    String? artist,
    String? fileName,
    String? lyric,
    String? link,
    String? path,
  }) {
    return Song(
      id: id ?? this.id,
      nameOfSong: nameOfSong ?? this.nameOfSong,
      artist: artist ?? this.artist,
      fileName: fileName ?? this.fileName,
      lyric: lyric ?? this.lyric,
      duration: duration ?? this.duration,
      link: link ?? this.link,
      path: path ?? this.path,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nameOfSong': nameOfSong,
      'artist': artist,
      FILE_NAME: fileName,
      LYRIC: lyric,
      'duration': duration,
      LINK: link,
      PATH: path,
    };
  }

  factory Song.fromMap(Map<String, dynamic> map) {
    return Song(
      id: (map['id'] as int).toString(),
      nameOfSong:
          map['nameOfSong'] != null ? map['nameOfSong'] as String : null,
      artist: map['artist'] != null ? map['artist'] as String : null,
      fileName: map[FILE_NAME] != null ? map[FILE_NAME] as String : null,
      lyric: map['lyric'] != null ? map['lyric'] as String : null,
      duration: map['duration'] != null ? map['duration'] as String : null,
      link: map[LINK] != null ? map[LINK] as String : null,
      path: map[PATH] != null ? map[PATH] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Song.fromJson(String source) =>
      Song.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    // return 'Music(id: $id, nameOfSong: $nameOfSong, artist: $artist, fileName: $fileName, lyric: $lyric)';
    return 'Music(id: $id, nameOfSong: $nameOfSong, artist: $artist, fileName: $fileName, duration: $duration, link: $link, path: $path)';
  }

  @override
  bool operator ==(covariant Song other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.nameOfSong == nameOfSong &&
        other.artist == artist &&
        other.fileName == fileName &&
        other.lyric == lyric &&
        other.duration == duration &&
        other.link == link &&
        other.path == path;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        nameOfSong.hashCode ^
        artist.hashCode ^
        fileName.hashCode ^
        lyric.hashCode ^
        duration.hashCode ^
        link.hashCode ^
        path.hashCode;
  }
}
