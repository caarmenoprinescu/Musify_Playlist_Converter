import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/all_playlists.dart';
import '../models/playlist.dart';

class SpotifyService {
  final String backendBaseUrl = "http://127.0.0.1:5000";

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

    if (response.statusCode == 200){
      var responseBodyofGetCurrentUserPlaylists = jsonDecode(response.body);
      (responseBodyofGetCurrentUserPlaylists['items'] as List).forEach((eachPlaylist){
        playlistsCurrentUser.add(PlaylistItem.fromJson(eachPlaylist),);
      });

      return playlistsCurrentUser;
    }

  }

   Future<Playlist> getEachPlaylist(String id) async {
    final response = await http.get(
      Uri.parse("$backendBaseUrl/spotify/playlists/$id"),
      headers: {"Authorization": "Bearer $accessToken"},
    );

    return Playlist.fromJson (jsonDecode(response.body));
  }
}
