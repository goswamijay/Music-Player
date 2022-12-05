import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:music_player_flutter/Services/Music_Provider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:just_audio/just_audio.dart';
import '../SongPlayScreen.dart';
import '../song_provider.dart';

class allsong extends StatefulWidget {
  const allsong({Key? key}) : super(key: key);

  @override
  State<allsong> createState() => _allsongState();
}

class _allsongState extends State<allsong> {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  final player = AudioPlayer();
  playSong(String? uri){
   try{
     player.setAudioSource(AudioSource.uri(Uri.parse(uri!)));
     player.play();
   }
   on Exception{
     log('error');
   }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestToPermission();
  }


  @override
  Widget build(BuildContext context) {


    return FutureBuilder<List<SongModel>>(
      future: _audioQuery.querySongs(
        sortType: null,
        uriType: UriType.EXTERNAL,
        ignoreCase: true,
      ),
      builder: (context, item) {
        if (item.data == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (item.data!.isEmpty) {
          return const Center(
            child: Text(
              "No Song Found",
            ),
          );
        }
        return ListView.builder(
            itemCount: item.data!.length,
            itemBuilder: (context, index) {
              return Consumer<FavoriteItem>(
                  builder: (context, value, child) {
                return ListTile(
                    onTap: () async {
                     // playSong(item.data![index].uri);
                     /* if(isPlaying){
                        await player.pause();
                      }else {
                        String? uri = item.data![index].uri;
                        var play = await player.setAudioSource(
                            AudioSource.uri(Uri.parse(uri!)));
                        await player.play();
  }*/
                      context.read<SongModelProvider>().setId(item.data![index].id);
                      context.read<SongModelProvider>().SetUri(item.data![index].uri!);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    SongPlayScreen(songModel: item.data![index],player: player,)));


                    },
                    title: Text(item.data![index].title),
                    leading: QueryArtworkWidget(
                      id:item.data![index].id,
                      type: ArtworkType.AUDIO,
                      nullArtworkWidget:const Icon(Icons.audiotrack),
                    ), //
                    trailing: IconButton(
                      onPressed: () {
                        if (value.selectedItem.contains(item.data![index].id)) {
                          value.Removesong(item.data![index].id);
                        } else {
                          value.AddSong(item.data![index].id);
                        }
                      },
                      icon: Icon(value.selectedItem.contains(item.data![index].id)
                          ? Icons.favorite
                          : Icons.favorite_border_outlined),
                    ));
              });
            });
      },
    );
  }

  void requestToPermission() async {
    if (!kIsWeb) {
      bool permissionStatus = await _audioQuery.permissionsStatus();
      if (!permissionStatus) {
        await _audioQuery.permissionsRequest();
      }
      setState(() {});
    }
  }
}
