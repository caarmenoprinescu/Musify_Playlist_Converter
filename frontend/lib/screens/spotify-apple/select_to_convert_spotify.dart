import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:playlist_converter_app/models/spotify/SListPlaylists.dart';
import '../../controller/spotify/SUser_playlists_controller.dart';
import '../../services/spotify_service.dart';
import 'converting_to_apple_screen.dart';

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
  final spotify = Get.put(SpotifyService(), permanent: true);

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    spotify.setTokens(widget.accessToken, widget.refreshToken);

    final myPlaylists = await spotify.getCurrentUsersPlaylists();

    allPlaylistsController.setList(myPlaylists);
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [const Color(0xFF537CFF).withAlpha(40), Colors.white],
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 100),
              child: Obx(() {
                if (allPlaylistsController.allPlaylists.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF537CFF)),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.only(top: 30, left: 12, right: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      const Text(
                        "Your Playlists",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF0D1B3E),
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Select playlists to convert",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF537CFF).withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 20),

                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: ShaderMask(
                            shaderCallback: (Rect bounds) {
                              return const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black,
                                  Colors.black,
                                  Colors.transparent,
                                ],
                                stops: [0.0, 0.05, 0.95, 1.0],
                              ).createShader(bounds);
                            },
                            blendMode: BlendMode.dstIn,
                            child: ListView.builder(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              itemCount:
                                  allPlaylistsController.allPlaylists.length,
                              itemBuilder: (context, index) {
                                final pl =
                                    allPlaylistsController.allPlaylists[index];
                                return _PlaylistTile(playlist: pl);
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),

          Positioned(
            bottom: 30,
            left: 50,
            right: 50,
            child: _buildNextButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildNextButton() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: const LinearGradient(
          colors: [Color(0xFF537CFF), Color(0xFF3F62D7)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF537CFF).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        onPressed: () => Get.to(() => AppleMusicConvertScreen()),
        child: const Text(
          "Next Step",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
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
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF537CFF)
                    : Colors.transparent,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl,
                          width: 65,
                          height: 65,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return _buildPlaceholder();
                          },
                          errorBuilder: (c, e, s) => _buildPlaceholder(),
                        )
                      : _buildPlaceholder(),
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
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0D1B3E),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${playlist.tracks.total} SONGS",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF537CFF).withOpacity(0.6),
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),

                if (isSelected)
                  const Icon(
                    Icons.check_circle_rounded,
                    color: Color(0xFF537CFF),
                    size: 24,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 65,
      height: 65,
      decoration: BoxDecoration(
        color: const Color(0xFF537CFF).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(
        Icons.music_note_rounded,
        color: Color(0xFF537CFF),
        size: 30,
      ),
    );
  }
}
