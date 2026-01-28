import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../controller/appleMusic/convert_flow_controller.dart';
import '../../controller/appleMusic/match_songs_controller.dart';
import '../../controller/appleMusic/matching_progress_controller.dart';
import '../../controller/spotify/SUser_playlists_controller.dart';
import '../../models/spotify/SListPlaylists.dart';
import '../../services/spotify_service.dart';

class AppleMusicConvertScreen extends StatefulWidget {
  const AppleMusicConvertScreen({super.key});

  @override
  State<AppleMusicConvertScreen> createState() =>
      _AppleMusicConvertScreenState();
}

class _AppleMusicConvertScreenState extends State<AppleMusicConvertScreen> {
  late final convertController = Get.put(ConvertController());
  final playlistsToConvert = Get.find<PlaylistsController>();
  final spotify = Get.find<SpotifyService>();
  late final flowController = Get.put(
    AppleConvertFlowController(
      spotify: spotify,
      convertController: convertController,
    ),
  );

  bool get allFinished {
    return playlistsToConvert.selectedItemList.every((id) {
      final p = Get.find<ConvertProgressController>(tag: id);
      return p.statusText.value == "Matching complete";
    });
  }

  @override
  void initState() {
    super.initState();

    for (final id in playlistsToConvert.selectedItemList) {
      if (!Get.isRegistered<ConvertProgressController>(tag: id)) {
        Get.put(ConvertProgressController(), tag: id);
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      flowController.startFlow(playlistsToConvert.selectedItemList);
    });
  }

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
            child: Obx(
              () => playlistsToConvert.allPlaylists.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        const Text(
                          "Converting",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF0D1B3E),
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "MATCHING ENGINE ACTIVE",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF537CFF).withOpacity(0.7),
                            letterSpacing: 2.0,
                          ),
                        ),
                        const SizedBox(height: 30),

                        Expanded(
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
                              padding: const EdgeInsets.fromLTRB(
                                15,
                                10,
                                15,
                                100,
                              ),
                              itemCount:
                                  playlistsToConvert.selectedItemList.length,
                              itemBuilder: (_, index) {
                                final id =
                                    playlistsToConvert.selectedItemList[index];
                                final pl = playlistsToConvert.allPlaylists
                                    .firstWhere((p) => p.id == id);

                                return _PlaylistTile(playlist: pl);
                              },
                            ),
                          ),
                        ),
                        Obx(() {
                          if (allFinished) {
                            return Positioned(
                              bottom: 30,
                              left: 50,
                              right: 50,
                              child: Container(
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF537CFF),
                                      Color(0xFF3F62D7),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(
                                        0xFF537CFF,
                                      ).withOpacity(0.3),
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
                                  onPressed: () => {_showExitDialog()},
                                  child: const Text(
                                    "Finish Setup",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        }),
                      ],
                    )
                  : const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF537CFF),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinishButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        onPressed: () {
          _showExitDialog();
        },
        child: const Text(
          "Finish Setup",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  void _showExitDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white.withOpacity(0.9),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
        title: Column(
          children: [
            Text(
              "SUCCESS",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: Colors.green.shade700,
                letterSpacing: 3.0,
              ),
            ),
          ],
        ),
        content: const Text(
          "Your playlists were created!\nCheck your Apple Music library now.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF0D1B3E),
            fontWeight: FontWeight.w500,
            height: 1.4,
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF537CFF),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  if (Platform.isAndroid) {
                    SystemNavigator.pop();
                  } else {
                    exit(0);
                  }
                },
                child: const Text(
                  "AWESOME",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
      barrierColor: const Color(0xFF0D1B3E).withOpacity(0.4),
    );
  }
}

class _PlaylistTile extends StatelessWidget {
  final PlaylistItem playlist;

  const _PlaylistTile({required this.playlist});

  @override
  Widget build(BuildContext context) {
    final progress = Get.find<ConvertProgressController>(tag: playlist.id);
    final imageUrl = playlist.images.isNotEmpty ? playlist.images[0].url : "";

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: imageUrl.isNotEmpty
                    ? Image.network(
                        imageUrl,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => _buildPlaceholder(),
                      )
                    : _buildPlaceholder(),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      playlist.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0D1B3E),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Obx(() {
                      bool isComplete =
                          progress.statusText.value == "Matching complete";

                      int songsFound = progress.matches.length;
                      int totalSongs = playlist.tracks.total;

                      return Text(
                        isComplete
                            ? "$totalSongs/$totalSongs SONGS ADDED"
                            : "$songsFound/$totalSongs SONGS MATCHED",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: Colors.black26,
                          letterSpacing: 1.2,
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          Obx(() {
            bool isComplete = progress.statusText.value == "Matching complete";

            return Column(
              children: [
                if (!isComplete) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progress.progress.value,
                      minHeight: 6,
                      backgroundColor: const Color(0xFF537CFF).withOpacity(0.1),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF537CFF),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  if (progress.matches.isNotEmpty) _buildMatchesList(progress),
                ] else
                  _buildSuccessMessage(),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSuccessMessage() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.greenAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_rounded, color: Colors.green, size: 22),
          SizedBox(width: 10),
          Text(
            "CONVERSION SUCCESSFUL",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w900,
              color: Colors.green,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchesList(ConvertProgressController progress) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF537CFF).withOpacity(0.04),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: progress.matches.reversed.take(3).map((match) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: [
                const Icon(Icons.check_rounded, size: 12, color: Colors.green),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "${match.name} • ${match.artist}",
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 60,
      height: 60,
      color: const Color(0xFF537CFF).withOpacity(0.1),
      child: const Icon(Icons.music_note, color: Color(0xFF537CFF)),
    );
  }
}

//old version

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../controller/appleMusic/convert_flow_controller.dart';
// import '../../controller/appleMusic/match_songs_controller.dart';
// import '../../controller/appleMusic/matching_progress_controller.dart';
// import '../../controller/spotify/SUser_playlists_controller.dart';
// import '../../models/spotify/SListPlaylists.dart';
// import '../../services/spotify_service.dart';
//
// class AppleMusicConvertScreen extends StatefulWidget {
//   const AppleMusicConvertScreen({super.key});
//
//   @override
//   State<AppleMusicConvertScreen> createState() =>
//       _AppleMusicConvertScreenState();
// }
//
// class _AppleMusicConvertScreenState extends State<AppleMusicConvertScreen> {
//   late final convertController = Get.put(ConvertController());
//   final playlistsToConvert = Get.find<PlaylistsController>();
//   final spotify = Get.find<SpotifyService>();
//   late final flowController = Get.put(
//     AppleConvertFlowController(
//       spotify: spotify,
//       convertController: convertController,
//     ),
//   );
//
//   @override
//   void initState() {
//     super.initState();
//
//     for (final id in playlistsToConvert.selectedItemList) {
//       if (!Get.isRegistered<ConvertProgressController>(tag: id)) {
//         Get.put(ConvertProgressController(), tag: id);
//       }
//     }
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       flowController.startFlow(playlistsToConvert.selectedItemList);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Stack(
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(
//                 top: 0,
//                 left: 5,
//                 right: 5,
//                 bottom: 100,
//               ),
//               child: Obx(
//                 () => playlistsToConvert.allPlaylists.isNotEmpty
//                     ? Padding(
//                         padding: const EdgeInsets.only(
//                           top: 30,
//                           left: 12,
//                           right: 12,
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             //title
//                             const SizedBox(height: 40),
//                             Text(
//                               "Converting your Playlists",
//                               textAlign: TextAlign.left,
//                               style: TextStyle(
//                                 fontSize: 23,
//                                 fontWeight: FontWeight.w700,
//                                 color: Colors.blue.shade900,
//                               ),
//                             ),
//                             const SizedBox(height: 5),
//                             Text(
//                               "Carefully choosing your best matches:",
//                               textAlign: TextAlign.left,
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.w300,
//                                 color: Color(0xFF537CFF),
//                               ),
//                             ),
//
//                             const SizedBox(height: 20),
//
//                             //listed playlists
//                             Expanded(
//                               child: Padding(
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 8.0,
//                                 ),
//                                 child: ShaderMask(
//                                   shaderCallback: (Rect bounds) {
//                                     return LinearGradient(
//                                       begin: Alignment.topCenter,
//                                       end: Alignment.bottomCenter,
//                                       colors: [
//                                         Colors.transparent,
//                                         Colors.black,
//                                         Colors.black,
//                                         Colors.transparent,
//                                       ],
//                                       stops: const [0.0, 0.05, 0.95, 1.0],
//                                     ).createShader(bounds);
//                                   },
//                                   blendMode: BlendMode.dstIn,
//                                   child: ClipRRect(
//                                     borderRadius: BorderRadius.circular(10),
//
//                                     child: ListView.builder(
//                                       padding: const EdgeInsets.symmetric(
//                                         vertical: 10,
//                                       ),
//                                       itemCount: playlistsToConvert
//                                           .selectedItemList
//                                           .length,
//                                       itemBuilder: (_, index) {
//                                         final id = playlistsToConvert
//                                             .selectedItemList[index];
//                                         final pl = playlistsToConvert
//                                             .allPlaylists
//                                             .firstWhere((p) => p.id == id);
//
//                                         return _PlaylistTile(playlist: pl);
//                                       },
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       )
//                     : const Center(
//                         child: Text(
//                           "No playlist found",
//                           style: TextStyle(fontSize: 18),
//                         ),
//                       ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _PlaylistTile extends StatelessWidget {
//   final PlaylistItem playlist;
//
//   const _PlaylistTile({required this.playlist});
//
//   @override
//   Widget build(BuildContext context) {
//     final progress = Get.find<ConvertProgressController>(tag: playlist.id);
//
//     final imageUrl = playlist.images.isNotEmpty ? playlist.images[0].url : "";
//
//     return GetBuilder<PlaylistsController>(
//       builder: (_) {
//         return Container(
//           margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
//           padding: const EdgeInsets.symmetric(horizontal: 10),
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Colors.white, Colors.white.withAlpha(204)],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//             borderRadius: BorderRadius.circular(20),
//             border: Border.all(color: Colors.white, width: 0.3),
//
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withAlpha(20),
//                 blurRadius: 15,
//                 offset: const Offset(0, 5),
//               ),
//             ],
//           ),
//
//           child: Column(
//             children: [
//               Row(
//                 children: [
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(12),
//                     child: FadeInImage(
//                       width: 70,
//                       height: 70,
//                       fit: BoxFit.cover,
//                       placeholder: const AssetImage(
//                         "images/placeholder2.png",
//                       ),
//
//                       image: imageUrl.isNotEmpty
//                           ? NetworkImage(imageUrl)
//                           : const AssetImage("images/placeholder2.png")
//                                 as ImageProvider,
//                     ),
//                   ),
//
//                   const SizedBox(width: 15),
//
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           playlist.name,
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                           style: const TextStyle(
//                             fontSize: 17,
//                             fontWeight: FontWeight.w700,
//                             color: Colors.black87,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         const SizedBox(height: 6),
//                         Obx(() {
//                           if (progress.statusText.value ==
//                               "Matching complete") {
//                             return const SizedBox.shrink();
//                           }
//
//                           return LinearProgressIndicator(
//                             value: progress.progress.value,
//                           );
//                         }),
//                         const SizedBox(height: 4),
//                         Obx(() => Text(progress.statusText.value)),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),
//               Row(
//                 children: [
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Obx(() {
//                           return Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: progress.matches.map((match) {
//                               return Padding(
//                                 padding: const EdgeInsets.only(top: 2),
//                                 child: Text(
//                                   "✓ ${match.name} – ${match.artist}",
//                                   maxLines: 1,
//                                   overflow: TextOverflow.ellipsis,
//                                   style: const TextStyle(
//                                     fontSize: 12,
//                                     color: Colors.black54,
//                                   ),
//                                 ),
//                               );
//                             }).toList(),
//                           );
//                         }),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
