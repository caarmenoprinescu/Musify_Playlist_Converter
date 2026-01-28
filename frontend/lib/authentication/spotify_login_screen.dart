import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http/http.dart' as http;
import 'package:playlist_converter_app/screens/spotify-apple/select_to_convert_spotify.dart';
import 'package:playlist_converter_app/utils/pkce.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? _codeVerifier;

  static const String spotifyClientId = 'e54ccea37cab469fbb0031eee9d7e45e';
  static const String redirectUri = 'musify://callback';
  static const String scopes =
      'playlist-read-private playlist-modify-private user-read-email user-read-private';

  Future<void> loginWithSpotify() async {
    try {
      _codeVerifier = generateCodeVerifier();
      final codeChallenge = generateCodeChallenge(_codeVerifier!);

      final authUrl =
          'https://accounts.spotify.com/authorize'
          '?client_id=$spotifyClientId'
          '&response_type=code'
          '&redirect_uri=$redirectUri'
          '&code_challenge_method=S256'
          '&code_challenge=$codeChallenge'
          '&scope=${Uri.encodeComponent(scopes)}';

      final result = await FlutterWebAuth2.authenticate(
        url: authUrl,
        callbackUrlScheme: 'musify',
      );

      final uri = Uri.parse(result);
      final code = uri.queryParameters['code'];

      if (code == null) {
        Fluttertoast.showToast(msg: 'Spotify login failed');
        return;
      }

      await exchangeCodeForToken(code);
    } catch (e) {
      Fluttertoast.showToast(msg: 'Spotify login error: $e');
    }
  }

  Future<void> exchangeCodeForToken(String code) async {
    final uri = Uri.parse('https://accounts.spotify.com/api/token');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'client_id': spotifyClientId,
        'grant_type': 'authorization_code',
        'code': code,
        'redirect_uri': redirectUri,
        'code_verifier': _codeVerifier!,
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Token exchange failed: ${response.body}');
    }

    final data = jsonDecode(response.body);

    final accessToken = data['access_token'];
    final refreshToken = data['refresh_token'];

    if (accessToken == null || refreshToken == null) {
      throw Exception('Missing tokens in response');
    }

    Get.off(
      () => SpotifyPlaylistScreen(
        accessToken: accessToken,
        refreshToken: refreshToken,
      ),
    );
  }

  void loginWithApple() async {
    // Placeholder – next to implement
    Fluttertoast.showToast(msg: "Apple Music login not implemented yet.");
  }

  void _showGlobalInfo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
        ),
        padding: const EdgeInsets.fromLTRB(30, 15, 30, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 30),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.auto_awesome_rounded,
                size: 40,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              "About Musify",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                letterSpacing: -1,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "The simplest way to keep your music library in sync across platforms.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.4,
              ),
            ),

            const SizedBox(height: 35),

            _buildInfoItem(
              Icons.security,
              "Privacy First",
              "We don't store your login data. Everything is handled via official, encrypted secure tokens.",
            ),
            const SizedBox(height: 20),
            _buildInfoItem(
              Icons.speed,
              "Lightning Fast",
              "Transfer thousands of songs in seconds with our optimized matching engine.",
            ),
            const SizedBox(height: 20),
            _buildInfoItem(
              Icons.verified_user_outlined,
              "Verified Quality",
              "We always look for the highest bitrate version of your tracks on the target platform.",
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 0,
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "Got it, thanks!",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.blue.withAlpha(15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.blueAccent, size: 24),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [const Color(0xFF537CFF).withAlpha(40), Colors.white],
              ),
            ),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),


                  Column(
                    children: [
                      Text(
                        "SYNC YOUR SOUND",
                        style: TextStyle(
                          color: Color(0xFF0D1B3E),
                          fontSize: 23,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 3),

                      Text(
                        "CHOOSE YOUR TRANSFER PATH",
                        style: TextStyle(
                          color: Color(0xFF537CFF).withAlpha(200),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  _buildOptionCard(
                    context,
                    leftLabel: "Spotify",
                    leftImg: "images/spotify_logo.png",
                    rightLabel: "Apple Music",
                    rightImg: "images/Apple_Music_icon.png",
                  ),

                  const SizedBox(height: 20),

                  _buildOptionCard(
                    context,
                    leftLabel: "Apple Music",
                    leftImg: "images/Apple_Music_icon.png",
                    rightLabel: "Spotify",
                    rightImg: "images/spotify_logo.png",
                  ),

                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.only(bottom: 40),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                            ),
                          ),
                          child: const Text(
                            "EARLY ACCESS",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "Move your playlists in seconds",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 10,
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 1,
                          width: 50,
                          color: const Color(0xFF537CFF).withOpacity(0.2),
                        ),
                        const SizedBox(height: 20),

                        Text(
                          "All your playlists are encrypted and secure during transfer.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color(0xFF537CFF).withAlpha(120),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 10),

                        Text(
                          "v1.0.4",
                          style: TextStyle(
                            color: const Color(0xFF537CFF).withAlpha(60),
                            fontSize: 10,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            right: 20,
            child: GestureDetector(
              onTap: () => _showGlobalInfo(context),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                    child: const Icon(
                      Icons.help_outline_rounded,
                      color: Colors.black26,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionCard(
    BuildContext context, {
    required String leftLabel,
    required String leftImg,
    required String rightLabel,
    required String rightImg,
  }) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(20),
                blurRadius: 25,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: loginWithSpotify,
              borderRadius: BorderRadius.circular(30),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 25,
                  horizontal: 15,
                ),
                child: Row(
                  children: [
                    Expanded(child: _buildPlatformBox(leftLabel, leftImg)),

                    Container(
                      padding: const EdgeInsets.all(8),

                      child: Icon(
                        Icons.swap_horiz_rounded,
                        color: const Color(0xFF537CFF),
                        size: 32,
                      ),
                    ),

                    Expanded(child: _buildPlatformBox(rightLabel, rightImg)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlatformBox(String label, String asset) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF537CFF).withAlpha(15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            asset,
            height: 33,
            errorBuilder: (context, e, s) =>
                const Icon(Icons.music_note, size: 22),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                letterSpacing: -0.5,
                fontSize: 13,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String desc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.blueAccent, size: 28),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                desc,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
