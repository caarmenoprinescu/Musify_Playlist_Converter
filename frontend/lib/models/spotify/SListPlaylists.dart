class AllPlaylists {
  String href;
  int limit;
  String? next;
  int offset;
  String? previous;
  int total;
  List<PlaylistItem> items;

  AllPlaylists({
    required this.href,
    required this.limit,
    this.next,
    required this.offset,
    this.previous,
    required this.total,
    required this.items,
  });

  factory AllPlaylists.fromJson(Map<String, dynamic> json) => AllPlaylists(
    href: json['href'] ?? '',
    limit: json['limit'] ?? 0,
    next: json['next'],
    offset: json['offset'] ?? 0,
    previous: json['previous'],
    total: json['total'] ?? 0,
    items: json['items'] == null
        ? []
        : List<PlaylistItem>.from(
            (json['items'] as List).map((x) => PlaylistItem.fromJson(x)),
          ),
  );

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

class PlaylistItem {
  bool collaborative;
  String description;
  ExternalUrls externalUrls;
  String href;
  String id;
  List<ImageData> images;
  String name;
  Owner owner;
  bool public;
  String snapshotId;
  SimpleTracks tracks;
  String type;
  String uri;

  PlaylistItem({
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

  factory PlaylistItem.fromJson(Map<String, dynamic> json) => PlaylistItem(
    collaborative: json['collaborative'] ?? false,
    description: json['description'] ?? '',
    externalUrls: ExternalUrls.fromJson(
      json['external_urls'] ?? <String, dynamic>{},
    ),
    href: json['href'] ?? '',
    id: json['id'] ?? '',
    images: json['images'] == null
        ? []
        : List<ImageData>.from(
            (json['images'] as List).map((x) => ImageData.fromJson(x)),
          ),
    name: json['name'] ?? '',
    owner: Owner.fromJson(json['owner'] ?? <String, dynamic>{}),
    public: json['public'] ?? false,
    snapshotId: json['snapshot_id'] ?? '',
    tracks: SimpleTracks.fromJson(json['tracks'] ?? <String, dynamic>{}),
    type: json['type'] ?? '',
    uri: json['uri'] ?? '',
  );

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
    'tracks': tracks.toJson(),
    'type': type,
    'uri': uri,
  };
}

class ExternalUrls {
  String spotify;

  ExternalUrls({required this.spotify});

  factory ExternalUrls.fromJson(Map<String, dynamic> json) =>
      ExternalUrls(spotify: json['spotify'] ?? '');

  Map<String, dynamic> toJson() => {'spotify': spotify};
}

class ImageData {
  String url;
  int height;
  int width;

  ImageData({required this.url, required this.height, required this.width});

  factory ImageData.fromJson(Map<String, dynamic> json) => ImageData(
    url: json['url'] ?? '',
    height: json['height'] ?? 0,
    width: json['width'] ?? 0,
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
  String displayName;

  Owner({
    required this.externalUrls,
    required this.href,
    required this.id,
    required this.type,
    required this.uri,
    required this.displayName,
  });

  factory Owner.fromJson(Map<String, dynamic> json) => Owner(
    externalUrls: ExternalUrls.fromJson(
      json['external_urls'] ?? <String, dynamic>{},
    ),
    href: json['href'] ?? '',
    id: json['id'] ?? '',
    type: json['type'] ?? '',
    uri: json['uri'] ?? '',
    displayName: json['display_name'] ?? '',
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

class SimpleTracks {
  String href;
  int total;

  SimpleTracks({required this.href, required this.total});

  factory SimpleTracks.fromJson(Map<String, dynamic> json) =>
      SimpleTracks(href: json['href'] ?? '', total: json['total'] ?? 0);

  Map<String, dynamic> toJson() => {'href': href, 'total': total};
}
