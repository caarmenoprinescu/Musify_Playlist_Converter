import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class AppleMusicService {
  static const MethodChannel _channel = MethodChannel('apple_music_auth');

  static Future<String> requestAuthorization() async {
    try {
      final status = await _channel.invokeMethod<String>(
        'requestAppleMusicAuth',
      );
      return status ?? 'unknown';
    } catch (e) {
      return 'error';
    }
  }

  static Future<String?> getUserToken(String developerToken) async {
    try {
      final token = await _channel.invokeMethod<String>(
        'getAppleMusicUserToken',
        {'developerToken': developerToken},
      );

      return token;
    } catch (e) {
      print('Error getting Apple Music user token: $e');
      return null;
    }
  }

  static Future<Map<String, bool>?> checkSubscription() async {
    try {
      final checks = await _channel.invokeMethod<Map>(
        'checkAppleMusicSubscription',
      );
      return Map<String, bool>.from(checks ?? {});
    } catch (e) {
      print('Error checking Apple Music subscription: $e');
      return null;
    }
  }

  static Future<String?> fetchDeveloperToken() async {
    const String backendUrl = 'http://192.168.0.118:5000/apple/developer-token';

    try {
      final response = await http.get(Uri.parse(backendUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['developerToken'];
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching developer token: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>> searchAppleMusicMatches({
    required List<String> terms,
    required String developerToken,
  }) async {
    const String baseUrl = 'http://192.168.0.118:5000';

    final uri = Uri.parse(
      '$baseUrl/apple/search',
    ).replace(queryParameters: {'terms': terms});

    try {
      final response = await http.get(
        uri,
        headers: {'Authorization': 'Bearer $developerToken'},
      );

      if (response.statusCode != 200) {
        throw Exception('Apple Music search failed: ${response.statusCode}');
      }

      return jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      print('Error searching Apple Music matches: $e');
      rethrow;
    }
  }

  static Future<String> createAppleMusicPlaylist({
    required String name,
    required String description,
    required bool public,
    required String developerToken,
    required String userToken,
  }) async {
    const String baseUrl = 'http://192.168.0.118:5000';
    final uri = Uri.parse('$baseUrl/apple/create-playlist');
    try {
      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $developerToken',
          'Music-User-Token': userToken,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'description': description,
          'public': public,
        }),
      );

      if (response.statusCode != 201 && response.statusCode != 200) {
        throw Exception(
          'Apple Music playlist creating failed: '
          '${response.statusCode} ${response.body}',
        );
      }
      final decoded = jsonDecode(response.body);

      final playlistId = decoded['data'][0]['id'] as String;

      return playlistId;
    } catch (e) {
      print(' Error creating Apple Music playlist: $e');
      rethrow;
    }
  }

  static Future<void> addTrackToPlaylist({
    required String id_playlist,
    required String id_song,
    required String developerToken,
    required String userToken,
  }) async {
    const String baseUrl = 'http://192.168.0.118:5000';
    final uri = Uri.parse('$baseUrl/apple/add-tracks');
    try {
      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $developerToken',
          'Music-User-Token': userToken,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'playlist_id': id_playlist, 'song_id': id_song}),
      );

      if (response.statusCode != 201 &&
          response.statusCode != 200 &&
          response.statusCode != 204) {
        throw Exception(
          'Adding song failed: ${response.statusCode} ${response.body}',
        );
      }
    } catch (e) {
      print('Error adding song to Apple Music playlist: $e');
      rethrow;
    }
  }

  static Future<void> addTracksToPlaylist({
    required String playlistId,
    required List<String> songIds,
    required String developerToken,
    required String userToken,
  }) async {
    const String baseUrl = 'http://192.168.0.118:5000';
    final uri = Uri.parse('$baseUrl/apple/add-tracks');

    try {
      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $developerToken',
          'Music-User-Token': userToken,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'playlist_id': playlistId, 'song_ids': songIds}),
      );

      if (response.statusCode != 201 &&
          response.statusCode != 200 &&
          response.statusCode != 204) {
        throw Exception(
          'Adding songs failed: ${response.statusCode} ${response.body}',
        );
      }
    } catch (e) {
      print('Error adding songs to Apple Music playlist: $e');
      rethrow;
    }
  }
}
