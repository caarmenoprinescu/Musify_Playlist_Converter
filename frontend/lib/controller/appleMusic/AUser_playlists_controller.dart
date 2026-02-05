import 'package:get/get.dart';

import '../../models/AppleMusic/AMPlaylist.dart';

class ApplePlaylistsController extends GetxController {
  RxList<LibraryPlaylist> _allPlaylists = <LibraryPlaylist>[].obs;
  RxList<String> _selectedItemList = <String>[].obs;
  RxBool _isSelectedAll = false.obs;

  List<LibraryPlaylist> get allPlaylists => _allPlaylists.value;

  List<String> get selectedItemList => _selectedItemList.value;

  bool get isSelectedAll => _isSelectedAll.value;

  setList(List<LibraryPlaylist> list) {
    _allPlaylists.value = list;
  }

  addSelectedItem(String selectedPlaylistID) {
    _selectedItemList.add(selectedPlaylistID);
  }

  deleteSelectedItem(String selectedPlaylistID) {
    _selectedItemList.remove(selectedPlaylistID);
  }

  setIsSelectedAllItems() {
    _isSelectedAll.value = !_isSelectedAll.value;
  }

  clearAllSelectedItems() {
    _selectedItemList.value.clear();
    update();
  }
}
