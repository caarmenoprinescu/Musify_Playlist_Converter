import 'package:get/get.dart';
import '../../models/AppleMusic/AMPlaylistMatch.dart';
import '../../models/spotify/SPlaylist.dart';
import '../../services/apple_music_service.dart';
import 'matching_progress_controller.dart';

class ConvertController extends GetxController {
  final termsPerPlaylist = <String, List<List<String>>>{}.obs;

  void prepareTerms(Playlist playlist) {
    final tracks = playlist.tracks;

    if (tracks == null || tracks.items.isEmpty) return;

    final List<List<String>> allTrackTerms = [];

    for (final item in tracks.items) {
      final terms = buildTermsForTrack(item);
      if (terms.isNotEmpty) {
        allTrackTerms.add(terms);
      }
    }

    termsPerPlaylist[playlist.id] = allTrackTerms;
  }

  List<String> buildTermsForTrack(TrackItem item) {
    final track = item.track;
    if (track == null) return [];

    final trackName = track.name.trim();
    if (trackName.isEmpty) return [];

    final artistName = track.artists.isNotEmpty
        ? track.artists.first.name.trim()
        : '';

    final terms = <String>[trackName, if (artistName.isNotEmpty) artistName];

    return terms.toSet().toList();
  }

  Future<List<dynamic>> runMatchingForPlaylist({
    required Playlist playlist,
    required String developerToken,
  }) async {
    final progress = Get.find<ConvertProgressController>(tag: playlist.id);

    progress.setRunning("Preparing tracks…");
    prepareTerms(playlist);

    final trackTermsList = termsPerPlaylist[playlist.id] ?? [];
    final total = trackTermsList.length;

    if (total == 0) {
      progress.error("No tracks");
      return [];
    }

    final List<dynamic> results = [];

    for (int i = 0; i < total; i++) {
      final trackTerms = trackTermsList[i];

      progress.updateProgress(i, total, "Searching ${i + 1} / $total");

      try {
        final res = await AppleMusicService.searchAppleMusicMatches(
          terms: trackTerms,
          developerToken: developerToken,
        );

        if (res['found'] == true) {
          final match = AppleMusicMatch.fromJson(res);
          progress.matches.add(match);
        }
        results.add({'terms': trackTerms, 'result': res});
      } catch (e) {
        results.add({'terms': trackTerms, 'error': e.toString()});
      }

      progress.updateProgress(i + 1, total, "Processed ${i + 1} / $total");
    }

    progress.done(text: "Matching complete");
    return results;
  }
}
