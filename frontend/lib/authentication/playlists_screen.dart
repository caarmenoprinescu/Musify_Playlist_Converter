import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:playlist_converter_app/models/all_playlists.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controller/users_playlists_controller.dart';
import '../models/playlist.dart';
import '../services/spotify_service.dart';


class SpotifyPlaylistScreen extends StatefulWidget {
  final String accessToken;
  final String refreshToken;

  const SpotifyPlaylistScreen({
    super.key,
    required this.accessToken,
    required this.refreshToken,
  });

  @override
  State<SpotifyPlaylistScreen> createState() => _SpotifyPlaylistScreenState();
}

class _SpotifyPlaylistScreenState extends State<SpotifyPlaylistScreen> {
  final allPlaylistsController = Get.put(PlaylistsController());

  final spotify = SpotifyService();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    spotify.setTokens(widget.accessToken, widget.refreshToken);

    final me = await spotify.getCurrentUser();
    final myPlaylists = await spotify.getCurrentUsersPlaylists();

    allPlaylistsController.setList(
      myPlaylists,
    );
    print("Length is:" + allPlaylistsController.allPlaylists.length.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 0,
                left: 5,
                right: 5,
                bottom: 100,
              ),
              child: Obx(
                () => allPlaylistsController.allPlaylists.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(
                          top: 30,
                          left: 12,
                          right: 12,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            //title
                            const SizedBox(height: 40),
                            Text(
                              "Your Playlists ",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 27,
                                fontWeight: FontWeight.w700,
                                color: Colors.blue.shade900,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Select playlists to convert:",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w300,
                                color: Color(0xFF537CFF),
                              ),
                            ),

                            const SizedBox(height: 20),

                            //listed playlists
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                ),
                                child: ShaderMask(
                                  shaderCallback: (Rect bounds) {
                                    return LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black,
                                        Colors.black,
                                        Colors.transparent,
                                      ],
                                      stops: const [0.0, 0.05, 0.95, 1.0],
                                    ).createShader(bounds);
                                  },
                                  blendMode: BlendMode.dstIn,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),

                                    child: ListView.builder(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      itemCount: allPlaylistsController
                                          .allPlaylists
                                          .length,
                                      itemBuilder: (context, index) {
                                        PlaylistItem pl = allPlaylistsController
                                            .allPlaylists[index];
                                        return _PlaylistTile(playlist: pl);
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),



                          ],
                        ),
                      )
                    : const Center(
                        child: Text(
                          "No playlist found",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
              ),

            ),
            Positioned(
              left: 20,
              right: 20,
              bottom: 20,
              child: Material(
                color:  Colors.white,
                shadowColor: Color(0xFF537CFF),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                  side: BorderSide(
                    color: Color(0xFF537CFF),
                    width: 0.7,
                  ),
                ),
                elevation: 0.2,
                child: InkWell(
                  splashColor: Color(0x26537CFF),
                  borderRadius: BorderRadius.circular(30),
                  onTap: () {
                    // Handle "Next" press
                  },
                  child: Container(
                    height: 50,
                    alignment: Alignment.center,
                    child:  Text(
                      "Next",
                      style: TextStyle(

                        color: Colors.blue.shade900,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }
}

class _PlaylistTile extends StatelessWidget {
  final PlaylistItem playlist;

  const _PlaylistTile({required this.playlist});

  @override
  Widget build(BuildContext context) {
    final allPlaylistsController = Get.find<PlaylistsController>();

    final imageUrl = playlist.images.isNotEmpty ? playlist.images[0].url : "";

    return GetBuilder<PlaylistsController>(
      builder: (_) {
        final isSelected = allPlaylistsController.selectedItemList.contains(
          playlist.id,
        );

        return GestureDetector(
          onTap: () {
            final id = playlist.id;
            if (isSelected) {
              allPlaylistsController.deleteSelectedItem(id);
            } else {
              allPlaylistsController.addSelectedItem(id);
            }
          },
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
                  color: isSelected ? Color(
                      0xFF537CFF).withOpacity(0.3) : Colors.black.withOpacity(0.08),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),

            child: Row(
              children: [

                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: FadeInImage(
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                    placeholder: const AssetImage(
                      "/Users/carmenoprinescu/StudioProjects/playlist_converter_app/lib/images/placeholder2.png",
                    ),

                    image: imageUrl.isNotEmpty
                        ? NetworkImage(imageUrl)
                        : const AssetImage(
                                "/Users/carmenoprinescu/StudioProjects/playlist_converter_app/lib/images/placeholder2.png",
                              )
                              as ImageProvider,
                  ),
                ),

                const SizedBox(width: 15),


                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        playlist.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(

                        "${playlist.tracks.total} songs",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
