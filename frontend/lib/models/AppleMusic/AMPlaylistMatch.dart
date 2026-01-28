class AppleMusicMatch {
  final String appleSongId;
  final String name;
  final String artist;
  final bool found;
  final String usedTerm;

  AppleMusicMatch({
    required this.appleSongId,
    required this.name,
    required this.artist,
    required this.found,
    required this.usedTerm,
  });

  factory AppleMusicMatch.fromJson(Map<String, dynamic> json) {
    return AppleMusicMatch(
      appleSongId: json['apple_song_id'],
      name: json['attributes']['name'],
      artist: json['attributes']['artistName'],
      found: json['found'],
      usedTerm: json['used_term'],
    );
  }
}