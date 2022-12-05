import 'package:flutter/foundation.dart';

class FavoriteItem with ChangeNotifier{
  List<int> _selectedItem = [];

  List<int> get selectedItem => _selectedItem;

  void AddSong(int value){
    _selectedItem.add(value);
    notifyListeners();
  }
  void Removesong(int value){
    _selectedItem.remove(value);
    notifyListeners();
  }

  void PauseSong(bool isPlaying){

  }

}