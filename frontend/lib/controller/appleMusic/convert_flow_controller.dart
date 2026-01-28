import 'package:get/get.dart';

import '../../services/apple_music_service.dart';
import '../../services/spotify_service.dart';
import 'match_songs_controller.dart';
import 'matching_progress_controller.dart';

class AppleConvertFlowController extends GetxController {
  final SpotifyService spotify;
  final ConvertController convertController;

  AppleConvertFlowController({
    required this.spotify,
    required this.convertController,
  });

  Future<void> startFlow(List<String> playlistIds) async {
    final developerToken = await AppleMusicService.fetchDeveloperToken();
    if (developerToken == null) return;

    final auth = await AppleMusicService.requestAuthorization();
    if (auth != 'authorized') return;

    final userToken = await AppleMusicService.getUserToken(developerToken);
    if (userToken == null) return;

    final futures = playlistIds.map((id) async {
      final playlist = await spotify.getPlaylistByID(id);

      //matching songs
      await convertController.runMatchingForPlaylist(
        playlist: playlist,
        developerToken: developerToken,
      );

      //create empty Apple playlist
      final applePlaylistId = await AppleMusicService.createAppleMusicPlaylist(
        name: playlist.name,
        description: playlist.description ?? '',
        public: playlist.public,
        developerToken: developerToken,
        userToken: userToken,
      );
      print(applePlaylistId);

      //add tracks to playlist
      final progress = Get.find<ConvertProgressController>(tag: playlist.id);

      for (final match in progress.matches) {
        await AppleMusicService.addTrackToPlaylist(
          id_playlist: applePlaylistId,
          id_song: match.appleSongId.toString(),
          developerToken: developerToken,
          userToken: userToken,
        );
      }
    }).toList();

    await Future.wait(futures);
  }
}
