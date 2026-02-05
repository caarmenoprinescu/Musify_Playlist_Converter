class PlaylistPlayParams {
  final String id;
  final String kind;
  final bool isLibrary;
  final String? globalId;

  PlaylistPlayParams({
    required this.id,
    required this.kind,
    required this.isLibrary,
    this.globalId,
  });

  factory PlaylistPlayParams.fromJson(Map<String, dynamic> json) {
    return PlaylistPlayParams(
      id: json['id'] ?? '',
      kind: json['kind'] ?? '',
      isLibrary: json['isLibrary'] ?? false,
      globalId: json['globalId'],
    );
  }
}

class PlaylistDescription {
  final String? standard;

  PlaylistDescription({this.standard});

  factory PlaylistDescription.fromJson(Map<String, dynamic>? json) {
    if (json == null) return PlaylistDescription();
    return PlaylistDescription(standard: json['standard']);
  }
}

class PlaylistArtwork {
  final int? width;
  final int? height;
  final String? url;

  PlaylistArtwork({this.width, this.height, this.url});

  factory PlaylistArtwork.fromJson(Map<String, dynamic>? json) {
    if (json == null) return PlaylistArtwork();
    return PlaylistArtwork(
      width: json['width'],
      height: json['height'],
      url: json['url'],
    );
  }
}

class PlaylistAttributes {
  final PlaylistPlayParams playParams;
  final bool canEdit;
  final String name;
  final PlaylistDescription? description;
  final String dateAdded;
  final PlaylistArtwork? artwork;
  final bool isPublic;
  final bool hasCatalog;

  PlaylistAttributes({
    required this.playParams,
    required this.canEdit,
    required this.name,
    this.description,
    required this.dateAdded,
    this.artwork,
    required this.isPublic,
    required this.hasCatalog,
  });

  factory PlaylistAttributes.fromJson(Map<String, dynamic> json) {
    return PlaylistAttributes(
      playParams: PlaylistPlayParams.fromJson(json['playParams'] ?? {}),
      canEdit: json['canEdit'] ?? false,
      name: json['name'] ?? '',
      description: PlaylistDescription.fromJson(json['description']),
      dateAdded: json['dateAdded'] ?? '',
      artwork: PlaylistArtwork.fromJson(json['artwork']),
      isPublic: json['isPublic'] ?? false,
      hasCatalog: json['hasCatalog'] ?? false,
    );
  }
}

class LibraryPlaylist {
  final String id;
  final String type;
  final String href;
  final PlaylistAttributes attributes;

  LibraryPlaylist({
    required this.id,
    required this.type,
    required this.href,
    required this.attributes,
  });

  factory LibraryPlaylist.fromJson(Map<String, dynamic> json) {
    return LibraryPlaylist(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      href: json['href'] ?? '',
      attributes: PlaylistAttributes.fromJson(json['attributes'] ?? {}),
    );
  }
}
