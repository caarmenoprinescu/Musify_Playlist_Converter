import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/spotify/SListPlaylists.dart';
import '../models/spotify/SPlaylist.dart';

class SpotifyService {
  final String backendBaseUrl = "http:' // ip address:5000";
  String? accessToken;
  String? refreshToken;

  void setTokens(String access, String refresh) {
    accessToken = access;
    refreshToken = refresh;
  }

  Future<Map<String, dynamic>> getCurrentUser() async {
    final response = await http.get(
      Uri.parse("$backendBaseUrl/spotify/me"),
      headers: {"Authorization": "Bearer $accessToken"},
    );

    return jsonDecode(response.body);
  }

  getCurrentUsersPlaylists() async {
    List<PlaylistItem> playlistsCurrentUser = [];
    final response = await http.get(
      Uri.parse("$backendBaseUrl/spotify/me/playlists"),
      headers: {"Authorization": "Bearer $accessToken"},
    );

    if (response.statusCode == 200) {
      var responseBodyofGetCurrentUserPlaylists = jsonDecode(response.body);
      (responseBodyofGetCurrentUserPlaylists['items'] as List).forEach((
        eachPlaylist,
      ) {
        playlistsCurrentUser.add(PlaylistItem.fromJson(eachPlaylist));
      });

      return playlistsCurrentUser;
    }
  }

  Future<Playlist> getPlaylistByID(String id) async {
    final response = await http.get(
      Uri.parse("$backendBaseUrl/spotify/playlists/$id"),
      headers: {"Authorization": "Bearer $accessToken"},
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to fetch playlist $id");
    }

    final data = jsonDecode(response.body);
    return Playlist.fromJson(data);
  }
}
