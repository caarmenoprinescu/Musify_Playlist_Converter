class AppleSong {
  final List<AppleSongData> data;

  AppleSong({required this.data});

  factory AppleSong.fromJson(Map<String, dynamic> json) {
    return AppleSong(
      data: (json['data'] as List<dynamic>)
          .map((e) => AppleSongData.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }
}

class AppleSongData {
  final String id;
  final String type;
  final String href;
  final AppleSongAttributes attributes;
  final AppleSongRelationships relationships;

  AppleSongData({
    required this.id,
    required this.type,
    required this.href,
    required this.attributes,
    required this.relationships,
  });

  factory AppleSongData.fromJson(Map<String, dynamic> json) {
    return AppleSongData(
      id: json['id'],
      type: json['type'],
      href: json['href'],
      attributes: AppleSongAttributes.fromJson(
        Map<String, dynamic>.from(json['attributes']),
      ),
      relationships: AppleSongRelationships.fromJson(
        Map<String, dynamic>.from(json['relationships']),
      ),
    );
  }
}

class AppleSongAttributes {
  final String albumName;
  final List<String> genreNames;
  final int trackNumber;
  final int durationInMillis;
  final String releaseDate;
  final String isrc;
  final AppleArtwork artwork;
  final String composerName;
  final ApplePlayParams playParams;
  final String url;
  final int discNumber;
  final bool hasLyrics;
  final bool isAppleDigitalMaster;
  final String name;
  final List<ApplePreview> previews;
  final String artistName;

  AppleSongAttributes({
    required this.albumName,
    required this.genreNames,
    required this.trackNumber,
    required this.durationInMillis,
    required this.releaseDate,
    required this.isrc,
    required this.artwork,
    required this.composerName,
    required this.playParams,
    required this.url,
    required this.discNumber,
    required this.hasLyrics,
    required this.isAppleDigitalMaster,
    required this.name,
    required this.previews,
    required this.artistName,
  });

  factory AppleSongAttributes.fromJson(Map<String, dynamic> json) {
    return AppleSongAttributes(
      albumName: json['albumName'],
      genreNames: List<String>.from(json['genreNames']),
      trackNumber: json['trackNumber'],
      durationInMillis: json['durationInMillis'],
      releaseDate: json['releaseDate'],
      isrc: json['isrc'],
      artwork: AppleArtwork.fromJson(
        Map<String, dynamic>.from(json['artwork']),
      ),
      composerName: json['composerName'],
      playParams: ApplePlayParams.fromJson(
        Map<String, dynamic>.from(json['playParams']),
      ),
      url: json['url'],
      discNumber: json['discNumber'],
      hasLyrics: json['hasLyrics'],
      isAppleDigitalMaster: json['isAppleDigitalMaster'],
      name: json['name'],
      previews: (json['previews'] as List<dynamic>)
          .map((e) => ApplePreview.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      artistName: json['artistName'],
    );
  }
}

class AppleArtwork {
  final int width;
  final int height;
  final String url;
  final String bgColor;
  final String textColor1;
  final String textColor2;
  final String textColor3;
  final String textColor4;

  AppleArtwork({
    required this.width,
    required this.height,
    required this.url,
    required this.bgColor,
    required this.textColor1,
    required this.textColor2,
    required this.textColor3,
    required this.textColor4,
  });

  factory AppleArtwork.fromJson(Map<String, dynamic> json) {
    return AppleArtwork(
      width: json['width'],
      height: json['height'],
      url: json['url'],
      bgColor: json['bgColor'],
      textColor1: json['textColor1'],
      textColor2: json['textColor2'],
      textColor3: json['textColor3'],
      textColor4: json['textColor4'],
    );
  }
}

class ApplePlayParams {
  final String id;
  final String kind;

  ApplePlayParams({required this.id, required this.kind});

  factory ApplePlayParams.fromJson(Map<String, dynamic> json) {
    return ApplePlayParams(id: json['id'], kind: json['kind']);
  }
}

class ApplePreview {
  final String url;

  ApplePreview({required this.url});

  factory ApplePreview.fromJson(Map<String, dynamic> json) {
    return ApplePreview(url: json['url']);
  }
}

class AppleSongRelationships {
  final AppleRelationship artists;
  final AppleRelationship albums;

  AppleSongRelationships({required this.artists, required this.albums});

  factory AppleSongRelationships.fromJson(Map<String, dynamic> json) {
    return AppleSongRelationships(
      artists: AppleRelationship.fromJson(
        Map<String, dynamic>.from(json['artists']),
      ),
      albums: AppleRelationship.fromJson(
        Map<String, dynamic>.from(json['albums']),
      ),
    );
  }
}

class AppleRelationship {
  final String href;
  final List<AppleRelationshipData> data;

  AppleRelationship({required this.href, required this.data});

  factory AppleRelationship.fromJson(Map<String, dynamic> json) {
    return AppleRelationship(
      href: json['href'],
      data: (json['data'] as List<dynamic>)
          .map(
            (e) => AppleRelationshipData.fromJson(Map<String, dynamic>.from(e)),
          )
          .toList(),
    );
  }
}

class AppleRelationshipData {
  final String id;
  final String type;
  final String href;

  AppleRelationshipData({
    required this.id,
    required this.type,
    required this.href,
  });

  factory AppleRelationshipData.fromJson(Map<String, dynamic> json) {
    return AppleRelationshipData(
      id: json['id'],
      type: json['type'],
      href: json['href'],
    );
  }
}
