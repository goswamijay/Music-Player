import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_player_flutter/Homepage.dart';
import 'package:music_player_flutter/Services/Music_Provider.dart';
import 'package:music_player_flutter/song_provider.dart';
import 'package:provider/provider.dart';

/*void main() {
  runApp(const MyApp());
}*/

Future<void> main() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (_)=> FavoriteItem()),
      ChangeNotifierProvider(create: (_)=>SongModelProvider())
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: ThemeData(useMaterial3: true),
      home: homepage(),
    ),);
  }
}