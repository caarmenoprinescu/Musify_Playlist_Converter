// welcome_screen.dart
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:playlist_converter_app/authentication/choose_app_screen.dart';
import 'package:playlist_converter_app/authentication/playlists_screen.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    _handleIncomingLinks();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  void _handleIncomingLinks() {

    _sub = linkStream.listen((String? link) {
      if (link != null && link.startsWith("musify://callback")) {
        final uri = Uri.parse(link);
        print("should work");
        final accessToken = uri.queryParameters['access_token'];
        final refreshToken = uri.queryParameters['refresh_token'];

        if (accessToken != null && refreshToken != null) {

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SpotifyPlaylistScreen(
                accessToken: accessToken,
                refreshToken: refreshToken,
              ),
            ),
          );
        }
      }
    }, onError: (err) {
      print("Error listening to links: $err");
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue.shade900,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(flex: 2),
                Icon(
                  Icons.music_note,
                  size: 100,
                  color: Colors.white.withOpacity(0.8),
                ),
                const SizedBox(height: 25),
                Text(
                  "Welcome to Musify!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Seamlessly transfer your playlists between Spotify and Apple Music",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const Spacer(flex: 2),
                Material(
                  color: Colors.white.withOpacity(0.8),
                  shadowColor: Colors.blue,
                  borderRadius: BorderRadius.circular(30),
                  elevation: 0.2,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    splashColor: Colors.white,
                    onTap: () {
                      Get.to(() => ChooseAppScreen());
                    },
                    child: Container(
                      width: 300,
                      height: 45,
                      alignment: Alignment.center,
                      child:  Text(
                        "Start",
                        style: TextStyle(
                          color: Colors.blue.shade900,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
                const Spacer(flex: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}