class Artwork {
  final int width;
  final int height;
  final String url;

  Artwork({required this.width, required this.height, required this.url});

  factory Artwork.fromJson(Map<String, dynamic> json) {
    return Artwork(
      width: json['width'] ?? 0,
      height: json['height'] ?? 0,
      url: json['url'] ?? '',
    );
  }
}

class PlayParams {
  final String id;
  final String kind;
  final bool isLibrary;
  final bool reporting;
  final String catalogId;

  PlayParams({
    required this.id,
    required this.kind,
    required this.isLibrary,
    required this.reporting,
    required this.catalogId,
  });

  factory PlayParams.fromJson(Map<String, dynamic> json) {
    return PlayParams(
      id: json['id'] ?? '',
      kind: json['kind'] ?? '',
      isLibrary: json['isLibrary'] ?? false,
      reporting: json['reporting'] ?? false,
      catalogId: json['catalogId'] ?? '',
    );
  }
}

class Attributes {
  final Artwork artwork;
  final String artistName;
  final int discNumber;
  final List<String> genreNames;
  final int durationInMillis;
  final String releaseDate;
  final String name;
  final bool hasLyrics;
  final String albumName;
  final int trackNumber;
  final PlayParams playParams;

  Attributes({
    required this.artwork,
    required this.artistName,
    required this.discNumber,
    required this.genreNames,
    required this.durationInMillis,
    required this.releaseDate,
    required this.name,
    required this.hasLyrics,
    required this.albumName,
    required this.trackNumber,
    required this.playParams,
  });

  factory Attributes.fromJson(Map<String, dynamic> json) {
    return Attributes(
      artwork: Artwork.fromJson(json['artwork'] ?? {}),
      artistName: json['artistName'] ?? '',
      discNumber: json['discNumber'] ?? 0,
      genreNames: List<String>.from(json['genreNames'] ?? []),
      durationInMillis: json['durationInMillis'] ?? 0,
      releaseDate: json['releaseDate'] ?? '',
      name: json['name'] ?? '',
      hasLyrics: json['hasLyrics'] ?? false,
      albumName: json['albumName'] ?? '',
      trackNumber: json['trackNumber'] ?? 0,
      playParams: PlayParams.fromJson(json['playParams'] ?? {}),
    );
  }
}

class PlaylistSong {
  final String id;
  final String type;
  final String href;
  final Attributes attributes;

  PlaylistSong({
    required this.id,
    required this.type,
    required this.href,
    required this.attributes,
  });

  factory PlaylistSong.fromJson(Map<String, dynamic> json) {
    return PlaylistSong(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      href: json['href'] ?? '',
      attributes: Attributes.fromJson(json['attributes'] ?? {}),
    );
  }
}

class PlaylistResponse {
  final List<PlaylistSong> data;

  PlaylistResponse({required this.data});

  factory PlaylistResponse.fromJson(Map<String, dynamic> json) {
    return PlaylistResponse(
      data:
          (json['data'] as List<dynamic>?)
              ?.map((item) => PlaylistSong.fromJson(item))
              .toList() ??
          [],
    );
  }
}
