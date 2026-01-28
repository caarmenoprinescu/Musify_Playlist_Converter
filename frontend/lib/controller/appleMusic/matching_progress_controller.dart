import 'package:get/get.dart';

import '../../models/AppleMusic/AMPlaylistMatch.dart';

class ConvertProgressController extends GetxController {
  final progress = 0.0.obs;
  final statusText = "Waiting…".obs;
  var matches = <AppleMusicMatch>[].obs;
  void setRunning(String text) {
    statusText.value = text;
  }

  void updateProgress(int current, int total, String text) {
    progress.value = total > 0 ? current / total : 0.0;
    statusText.value = text;
  }

  void done({String text = "Done"}) {
    progress.value = 1.0;
    statusText.value = text;
  }

  void error(String text) {
    statusText.value = text;
  }
}