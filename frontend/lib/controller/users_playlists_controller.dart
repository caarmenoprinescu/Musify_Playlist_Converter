import 'package:get/get.dart';
import '../models/all_playlists.dart';

class PlaylistsController extends GetxController {
  RxList<PlaylistItem> _allPlaylists = <PlaylistItem>[].obs;
  RxList<String> _selectedItemList = <String>[].obs;
  RxBool _isSelectedAll = false.obs;


  List<PlaylistItem> get allPlaylists => _allPlaylists.value;

  List<String> get selectedItemList => _selectedItemList.value;

  bool get isSelectedAll => _isSelectedAll.value;


  setList(List<PlaylistItem> list) {
    _allPlaylists.value = list;
  }

  addSelectedItem(String selectedPlaylistID) {
    _selectedItemList.value.add(selectedPlaylistID);
    update();
  }

  deleteSelectedItem(String selectedPlaylistID) {
    _selectedItemList.value.remove(selectedPlaylistID);
    update();
  }

  setIsSelectedAllItems() {
    _isSelectedAll.value = !_isSelectedAll.value;
  }

  clearAllSelectedItems(){
    _selectedItemList.value.clear();
    update();
  }

}
