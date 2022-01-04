import 'package:flutter/material.dart';

class MenuProvider with ChangeNotifier {

  bool isShowingMenu = true;
  bool isPlayingMusic = true;
  bool isPlayingSound = true;

  void setIsShowingMenu(bool _isShowingMenu) async {
    isShowingMenu = _isShowingMenu;
    notifyListeners();
  }

  void setIsPlayingMusic(bool _isPlayingMusic) async {
    isPlayingMusic = _isPlayingMusic;
    notifyListeners();
  }

  void setIsPlayingSound(bool _isPlayingSound) async {
    isPlayingSound = _isPlayingSound;
    notifyListeners();
  }

}