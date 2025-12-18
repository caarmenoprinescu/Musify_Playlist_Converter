import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:playlist_converter_app/authentication/playlists_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controller/users_playlists_controller.dart';
import '../models/streaming_app.dart';
import '../services/spotify_service.dart';

class ChooseAppScreen extends StatefulWidget {
  const ChooseAppScreen({super.key});

  @override
  State<ChooseAppScreen> createState() => _ChooseAppScreenState();
}

class _ChooseAppScreenState extends State<ChooseAppScreen> {
  final allPlaylistsController = Get.put(PlaylistsController());
  StreamingApp? selectedApp;
  final spotify = SpotifyService();

  final String backendUrl = "http://127.0.0.1:5000/login";

  void loginWithSpotify() async {
    final uri = Uri.parse(backendUrl);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $backendUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    final apps = [
      StreamingApp(
        name: "Spotify",
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/8/84/Spotify_icon.svg',
      ),
      StreamingApp(name: "Apple Music", imageUrl: "..."),
      StreamingApp(name: "YouTube Music", imageUrl: "..."),
    ];
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 100),

                  Text(
                    "Choose your app:",
                    style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.w700,
                      color: Colors.blue.shade900,
                    ),
                  ),

                  const SizedBox(height: 5),

                  const Text(
                    "Select one of the streaming services below",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w300,
                      color: Color(0xFF537CFF),
                    ),
                  ),

                  const SizedBox(height: 40),

                  ...apps.map(
                    (app) => _AppTile(
                      app: app,
                      isSelected: selectedApp?.name == app.name,
                      onTap: () => setState(() => selectedApp = app),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Material(
                    color: selectedApp == null
                        ? Colors.grey
                        : Colors.blue.shade900,
                    borderRadius: BorderRadius.circular(40),
                    child: InkWell(
                      highlightColor: selectedApp == null
                          ? Colors.transparent
                          : Colors.blue,
                      borderRadius: BorderRadius.circular(40),
                      onTap: () {
                        if (selectedApp == null) return;



                        if (selectedApp!.name == "Spotify") {

                          loginWithSpotify();
                        } else if (selectedApp!.name == "Apple Music") {
                          // Get.to(() => AppleMusicPlaylistScreen());
                        } else if (selectedApp!.name == "YouTube Music") {
                          // Get.to(() => YoutubeMusicPlaylistScreen());
                        }
                      },
                      child: Container(
                        width: 200,
                        height: 45,
                        alignment: Alignment.center,
                        child: const Text(
                          "Next",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppTile extends StatelessWidget {
  final StreamingApp app;
  final bool isSelected;
  final VoidCallback onTap;

  const _AppTile({
    required this.app,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 95,

        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.white.withOpacity(0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Color(0xFF537CFF) : Colors.white,
            width: 0.3,
          ),

          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? Color(
                  0xFF537CFF).withOpacity(0.3)
                  : Colors.black.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),

        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 60,
                height: 55,
                child: SvgPicture.network(
                  app.imageUrl!,
                  fit: BoxFit.contain,
                  placeholderBuilder: (context) => Image.asset(
                    '/Users/carmenoprinescu/StudioProjects/playlist_converter_app/lib/images/placeholder2.png',
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 15),
            Text(
              app.name!,
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w700,
                color: isSelected ? Color(0xFF537CFF) : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
