class Playlist {
  bool collaborative;
  String? description;
  ExternalUrls externalUrls;
  String href;
  String id;
  List<Image> images;
  String name;
  Owner owner;
  bool public;
  String snapshotId;
  Tracks? tracks;
  String type;
  String uri;

  Playlist({
    required this.collaborative,
    required this.description,
    required this.externalUrls,
    required this.href,
    required this.id,
    required this.images,
    required this.name,
    required this.owner,
    required this.public,
    required this.snapshotId,
    required this.tracks,
    required this.type,
    required this.uri,
  });

  factory Playlist.fromJson(Map<String, dynamic> json) {
    List<Image> parsedImages = [];
    if (json['images'] != null) {
      parsedImages = List<Image>.from(
          json['images'].map((i) => Image.fromJson(i)));
    }

    Tracks? parsedTracks;
    if (json['tracks'] != null) {
      parsedTracks = Tracks.fromJson(json['tracks']);
    }

    return Playlist(
      collaborative: json['collaborative'] ?? false,
      description: json['description'],
      externalUrls: ExternalUrls.fromJson(json['external_urls'] ?? {}),
      href: json['href'] ?? "",
      id: json['id'] ?? "",
      images: parsedImages,
      name: json['name'] ?? "",
      owner: Owner.fromJson(json['owner'] ?? {}),
      public: json['public'] ?? false,
      snapshotId: json['snapshot_id'] ?? "",
      tracks: parsedTracks,
      type: json['type'] ?? "",
      uri: json['uri'] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    'collaborative': collaborative,
    'description': description,
    'external_urls': externalUrls.toJson(),
    'href': href,
    'id': id,
    'images': images.map((x) => x.toJson()).toList(),
    'name': name,
    'owner': owner.toJson(),
    'public': public,
    'snapshot_id': snapshotId,
    'tracks': tracks?.toJson(),
    'type': type,
    'uri': uri,
  };
}

class ExternalUrls {
  String? spotify;

  ExternalUrls({this.spotify});

  factory ExternalUrls.fromJson(Map<String, dynamic> json) =>
      ExternalUrls(spotify: json['spotify']);

  Map<String, dynamic> toJson() => {'spotify': spotify};
}

class Image {
  String url;
  int? height;
  int? width;

  Image({required this.url, this.height, this.width});

  factory Image.fromJson(Map<String, dynamic> json) => Image(
    url: json['url'] ?? "",
    height: json['height'],
    width: json['width'],
  );

  Map<String, dynamic> toJson() => {
    'url': url,
    'height': height,
    'width': width,
  };
}

class Owner {
  ExternalUrls externalUrls;
  String href;
  String id;
  String type;
  String uri;
  String? displayName;

  Owner({
    required this.externalUrls,
    required this.href,
    required this.id,
    required this.type,
    required this.uri,
    required this.displayName,
  });

  factory Owner.fromJson(Map<String, dynamic> json) => Owner(
    externalUrls:
    ExternalUrls.fromJson(json['external_urls'] ?? {}),
    href: json['href'] ?? "",
    id: json['id'] ?? "",
    type: json['type'] ?? "",
    uri: json['uri'] ?? "",
    displayName: json['display_name'],
  );

  Map<String, dynamic> toJson() => {
    'external_urls': externalUrls.toJson(),
    'href': href,
    'id': id,
    'type': type,
    'uri': uri,
    'display_name': displayName,
  };
}

class Tracks {
  String href;
  int? limit;
  String? next;
  int? offset;
  String? previous;
  int? total;
  List<TrackItem> items;

  Tracks({
    required this.href,
    this.limit,
    this.next,
    this.offset,
    this.previous,
    this.total,
    required this.items,
  });

  factory Tracks.fromJson(Map<String, dynamic> json) {
    List<TrackItem> safeItems = [];

    if (json['items'] != null) {
      for (var item in json['items']) {
        if (item['track'] != null) {
          safeItems.add(TrackItem.fromJson(item));
        }
      }
    }

    return Tracks(
      href: json['href'] ?? "",
      limit: json['limit'],
      next: json['next'],
      offset: json['offset'],
      previous: json['previous'],
      total: json['total'],
      items: safeItems,
    );
  }

  Map<String, dynamic> toJson() => {
    'href': href,
    'limit': limit,
    'next': next,
    'offset': offset,
    'previous': previous,
    'total': total,
    'items': items.map((x) => x.toJson()).toList(),
  };
}

class TrackItem {
  String addedAt;
  AddedBy? addedBy;
  bool isLocal;
  Track? track;

  TrackItem({
    required this.addedAt,
    this.addedBy,
    required this.isLocal,
    required this.track,
  });

  factory TrackItem.fromJson(Map<String, dynamic> json) => TrackItem(
    addedAt: json['added_at'] ?? "",
    addedBy: json['added_by'] != null
        ? AddedBy.fromJson(json['added_by'])
        : null,
    isLocal: json['is_local'] ?? false,
    track: json['track'] != null
        ? Track.fromJson(json['track'])
        : null,
  );

  Map<String, dynamic> toJson() => {
    'added_at': addedAt,
    'added_by': addedBy?.toJson(),
    'is_local': isLocal,
    'track': track?.toJson(),
  };
}

class AddedBy {
  ExternalUrls externalUrls;
  String href;
  String id;
  String type;
  String uri;

  AddedBy({
    required this.externalUrls,
    required this.href,
    required this.id,
    required this.type,
    required this.uri,
  });

  factory AddedBy.fromJson(Map<String, dynamic> json) => AddedBy(
    externalUrls:
    ExternalUrls.fromJson(json['external_urls'] ?? {}),
    href: json['href'] ?? "",
    id: json['id'] ?? "",
    type: json['type'] ?? "",
    uri: json['uri'] ?? "",
  );

  Map<String, dynamic> toJson() => {
    'external_urls': externalUrls.toJson(),
    'href': href,
    'id': id,
    'type': type,
    'uri': uri,
  };
}

class Track {
  Album? album;
  List<Artist> artists;
  List<String> availableMarkets;
  int? discNumber;
  int? durationMs;
  bool explicit;
  ExternalIds? externalIds;
  ExternalUrls? externalUrls;
  String href;
  String id;
  bool? isPlayable;
  Map<String, dynamic>? linkedFrom;
  Restrictions? restrictions;
  String name;
  int? popularity;
  String? previewUrl;
  int? trackNumber;
  String type;
  String uri;
  bool isLocal;

  Track({
    required this.album,
    required this.artists,
    required this.availableMarkets,
    this.discNumber,
    this.durationMs,
    required this.explicit,
    this.externalIds,
    this.externalUrls,
    required this.href,
    required this.id,
    this.isPlayable,
    this.linkedFrom,
    this.restrictions,
    required this.name,
    this.popularity,
    this.previewUrl,
    this.trackNumber,
    required this.type,
    required this.uri,
    required this.isLocal,
  });

  factory Track.fromJson(Map<String, dynamic> json) => Track(
    album: json['album'] != null
        ? Album.fromJson(json['album'])
        : null,
    artists: json['artists'] != null
        ? List<Artist>.from(
        json['artists'].map((x) => Artist.fromJson(x)))
        : [],
    availableMarkets: json['available_markets'] != null
        ? List<String>.from(json['available_markets'])
        : [],
    discNumber: json['disc_number'],
    durationMs: json['duration_ms'],
    explicit: json['explicit'] ?? false,
    externalIds: json['external_ids'] != null
        ? ExternalIds.fromJson(json['external_ids'])
        : null,
    externalUrls: json['external_urls'] != null
        ? ExternalUrls.fromJson(json['external_urls'])
        : null,
    href: json['href'] ?? "",
    id: json['id'] ?? "",
    isPlayable: json['is_playable'],
    linkedFrom: json['linked_from'],
    restrictions: json['restrictions'] != null
        ? Restrictions.fromJson(json['restrictions'])
        : null,
    name: json['name'] ?? "",
    popularity: json['popularity'],
    previewUrl: json['preview_url'],
    trackNumber: json['track_number'],
    type: json['type'] ?? "",
    uri: json['uri'] ?? "",
    isLocal: json['is_local'] ?? false,
  );

  Map<String, dynamic> toJson() => {
    'album': album?.toJson(),
    'artists': artists.map((x) => x.toJson()).toList(),
    'available_markets': availableMarkets,
    'disc_number': discNumber,
    'duration_ms': durationMs,
    'explicit': explicit,
    'external_ids': externalIds?.toJson(),
    'external_urls': externalUrls?.toJson(),
    'href': href,
    'id': id,
    'is_playable': isPlayable,
    'linked_from': linkedFrom,
    'restrictions': restrictions?.toJson(),
    'name': name,
    'popularity': popularity,
    'preview_url': previewUrl,
    'track_number': trackNumber,
    'type': type,
    'uri': uri,
    'is_local': isLocal,
  };
}

class Album {
  String albumType;
  int? totalTracks;
  List<String> availableMarkets;
  ExternalUrls externalUrls;
  String href;
  String id;
  List<Image> images;
  String name;
  String? releaseDate;
  String? releaseDatePrecision;
  Restrictions? restrictions;
  String type;
  String uri;
  List<Artist> artists;

  Album({
    required this.albumType,
    this.totalTracks,
    required this.availableMarkets,
    required this.externalUrls,
    required this.href,
    required this.id,
    required this.images,
    required this.name,
    this.releaseDate,
    this.releaseDatePrecision,
    this.restrictions,
    required this.type,
    required this.uri,
    required this.artists,
  });

  factory Album.fromJson(Map<String, dynamic> json) => Album(
    albumType: json['album_type'] ?? "",
    totalTracks: json['total_tracks'],
    availableMarkets: json['available_markets'] != null
        ? List<String>.from(json['available_markets'])
        : [],
    externalUrls: ExternalUrls.fromJson(json['external_urls'] ?? {}),
    href: json['href'] ?? "",
    id: json['id'] ?? "",
    images: json['images'] != null
        ? List<Image>.from(
        json['images'].map((x) => Image.fromJson(x)))
        : [],
    name: json['name'] ?? "",
    releaseDate: json['release_date'],
    releaseDatePrecision: json['release_date_precision'],
    restrictions: json['restrictions'] != null
        ? Restrictions.fromJson(json['restrictions'])
        : null,
    type: json['type'] ?? "",
    uri: json['uri'] ?? "",
    artists: json['artists'] != null
        ? List<Artist>.from(
        json['artists'].map((x) => Artist.fromJson(x)))
        : [],
  );

  Map<String, dynamic> toJson() => {
    'album_type': albumType,
    'total_tracks': totalTracks,
    'available_markets': availableMarkets,
    'external_urls': externalUrls.toJson(),
    'href': href,
    'id': id,
    'images': images.map((x) => x.toJson()).toList(),
    'name': name,
    'release_date': releaseDate,
    'release_date_precision': releaseDatePrecision,
    'restrictions': restrictions?.toJson(),
    'type': type,
    'uri': uri,
    'artists': artists.map((x) => x.toJson()).toList(),
  };
}

class Artist {
  ExternalUrls externalUrls;
  String href;
  String id;
  String name;
  String type;
  String uri;

  Artist({
    required this.externalUrls,
    required this.href,
    required this.id,
    required this.name,
    required this.type,
    required this.uri,
  });

  factory Artist.fromJson(Map<String, dynamic> json) => Artist(
    externalUrls:
    ExternalUrls.fromJson(json['external_urls'] ?? {}),
    href: json['href'] ?? "",
    id: json['id'] ?? "",
    name: json['name'] ?? "",
    type: json['type'] ?? "",
    uri: json['uri'] ?? "",
  );

  Map<String, dynamic> toJson() => {
    'external_urls': externalUrls.toJson(),
    'href': href,
    'id': id,
    'name': name,
    'type': type,
    'uri': uri,
  };
}

class ExternalIds {
  String? isrc;
  String? ean;
  String? upc;

  ExternalIds({this.isrc, this.ean, this.upc});

  factory ExternalIds.fromJson(Map<String, dynamic> json) => ExternalIds(
    isrc: json['isrc'],
    ean: json['ean'],
    upc: json['upc'],
  );

  Map<String, dynamic> toJson() =>
      {'isrc': isrc, 'ean': ean, 'upc': upc};
}

class Restrictions {
  String? reason;

  Restrictions({this.reason});

  factory Restrictions.fromJson(Map<String, dynamic> json) =>
      Restrictions(reason: json['reason']);

  Map<String, dynamic> toJson() => {'reason': reason};
}