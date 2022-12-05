import 'dart:core';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class SongModelProvider with ChangeNotifier {
  AudioPlayer audioPlayer = AudioPlayer();
  Duration _duration = Duration();
  Duration get duration => _duration;
  Duration _position = Duration();
  Duration get position => _position;

  int _id = 0;

  int get id => _id;
  String _string = "";

  String get uri => _string;

  void setId(int id) {
    _id = id;
    notifyListeners();
  }

  void SetUri(String uri) {
    _string = uri;
    print(uri);
    notifyListeners();
  }

  void playMusic(uri) {
    audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri)));
    audioPlayer.play();
    audioPlayer.durationStream.listen((d) {
      _duration = d!;
      notifyListeners();
    });
    audioPlayer.positionStream.listen((p) {
      _position = p!;
      notifyListeners();
    });
    audioPlayer.seek(position) ;

  }

  void pauseMusic(uri) {
    audioPlayer.pause();
  }
  dynamic duration1(uri){
    audioPlayer.durationStream.listen((d) {
      _duration = d!;
      notifyListeners();
    });
  }
  dynamic position1(){
    audioPlayer.positionStream.listen((p) {
      _position = p!;
      notifyListeners();
    });
  }
  dynamic seek( Duration? duration0){
    audioPlayer.seek(duration0);
  }

  void onPreviousSongButtonPressed() {
    audioPlayer.seekToPrevious();
  }

  void onNextSongButtonPressed() {
    audioPlayer.seekToNext();
  }
}