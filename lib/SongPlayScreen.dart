import 'dart:math';
import 'dart:developer';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:line_icons/line_icons.dart';
import 'package:music_player_flutter/allsong_screen/allscreen_screen.dart';
import 'package:music_player_flutter/song_provider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

import 'Services/Music_Provider.dart';


class SongPlayScreen extends StatefulWidget {


  const SongPlayScreen({ required this.songModel,required this.player,Key? key}) : super(key: key);
  final SongModel songModel;
  final AudioPlayer player;

  @override
  State<SongPlayScreen> createState() => _SongPlayScreenState();
}


class _SongPlayScreenState extends State<SongPlayScreen> {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  final player = AudioPlayer();
  bool _isplaying = true;
  Duration _duration = Duration();
  Duration _position = Duration();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   // playSong();
    ProviderPlay();
  }
  void ProviderPlay(){
    try{
      context.read<SongModelProvider>().playMusic(widget.songModel.uri!);
      tag: MediaItem(
        id: "${widget.songModel.id}",
        album: "${widget.songModel.album}",
        title:  "${widget.songModel.displayNameWOExt}",
       artUri: Uri.parse('https://example.com/albumart.jpg'),
      );
      widget.player.play();
      _isplaying = true;

    }
    on Exception{
      print("error");
    }
  }

  void playSong(){
    try{
    widget.player.setAudioSource(AudioSource.uri(Uri.parse(widget.songModel.uri!)));
    tag: MediaItem(
      id: "${widget.songModel.id}",
      album: "${widget.songModel.album}",
      title:  "${widget.songModel.displayNameWOExt}",
      artUri: Uri.parse('0'),

    );
    widget.player.play();
    _isplaying = true;
    }
    on Exception{
     print("error");
    }
    widget.player.durationStream.listen((d) {
      setState(() {
       // _duration = d!;
      });
    });
    widget.player.positionStream.listen((p) {
      setState(() {
        _position = p!;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    String title = widget.songModel.displayNameWOExt;
    title.substring(0,15);


    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 26,
                    color: Color.fromRGBO(21, 91, 221, 1),
                  )),
              const SizedBox(
                height: 20,
              ),
              Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(blurRadius: 6.0, spreadRadius: 0.20),
                  ],
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.pink,
                  radius: size.height / 5,
                  child: ArtWorkWidget(),
                ),
              ),
              SizedBox(
                height: size.height / 20,
              ),
               Row(
                 mainAxisAlignment: MainAxisAlignment.start,
                 children: [
                   Column(
                     mainAxisAlignment: MainAxisAlignment.start,
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Padding(
                         padding: const EdgeInsets.only(left: 8.0),
                         child: Text(
                   title.substring(0,19) + '...',
                           style: const TextStyle(
                           fontSize: 26,
                           fontWeight: FontWeight.bold,
                           overflow: TextOverflow.clip),
                         ),
                       ),
                       Padding(
                         padding: const EdgeInsets.only(left: 8.0),
                         child: Text(
                           widget.songModel.artist.toString() == "<unknown>" ? "Unknown Artist" : widget.songModel.artist.toString(),
                           style: const TextStyle(
                               fontSize: 15, overflow: TextOverflow.ellipsis),
                         ),
                       ),
                     ],

                   ),
                   Column(
                     children: [
                       Consumer
                       <FavoriteItem>(
                       builder: (context, value, child) {
                         return IconButton(
                             onPressed: () {
                               if(value.selectedItem.contains(widget.songModel.id)){
                                 value.Removesong(widget.songModel.id);
                               }else{
                                 value.AddSong(widget.songModel.id);
                               }

                             },
                             icon: Icon(value.selectedItem.contains(widget.songModel.id)
                                 ? Icons.favorite
                                 : Icons.favorite_border_outlined,
                               size: 30,
                             ));
                       },
                       ),
                     ],
                   )

                 ],
               ),

              Padding(
                padding: const EdgeInsets.all(25.0),
                child:Consumer<SongModelProvider>(builder: (context, value, child) {
                  return ProgressBar(
                    progress: context.read<SongModelProvider>().position,

                    total: context.read<SongModelProvider>().duration,
                    progressBarColor: Colors.red,
                    baseBarColor: Colors.red.withOpacity(0.24),
                    thumbColor: Colors.red,
                    onSeek: (Duration duration1) {
                    context.read<SongModelProvider>().seek(duration1);
                    },
                  );},
                ),
              ),

              /* SizedBox(
                height: size.height/50,
              ),*/

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    padding: const EdgeInsets.all(0),
                    splashRadius: 24,
                    onPressed: () {


                    },
                    icon:
                        Icon(Icons.shuffle, color: Colors.black)
                  ),
                  IconButton(
                      onPressed: () {
                      setState(() {
                        widget.player.seekToPrevious();

                      });
                      },
                      icon: const Icon(
                        Icons.skip_previous,
                        size: 50,
                      )),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          _isplaying = !_isplaying;
                          if(_isplaying){
                            context.read<SongModelProvider>().pauseMusic(widget.songModel.uri);
                          }
                          else{
                            context.read<SongModelProvider>().playMusic(widget.songModel.uri);
                          }
                        });

                      },
                      icon:  Icon( _isplaying ?
                        Icons.play_circle_fill : Icons.pause_circle_filled,
                        size: 100,
                        color: Colors.red,
                      )),
                  IconButton(
                      onPressed: () {
                        widget.player.seekToNext();
                      },
                      icon: const Icon(
                        Icons.skip_next,
                        size: 50,
                      )),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.sync,
                        size: 25,
                      )),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                        onPressed: () {
                        },
                        icon: const Icon(
                          Icons.add_circle_outline,
                          size: 25,
                        )),
                    IconButton(
                        onPressed: () {
                        },
                        icon: const Icon(
                          Icons.download_sharp,
                          size: 25,
                        )),

                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          CupertinoIcons.music_note_list,
                          size: 25,
                        )),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.more_horiz,
                          size: 25,
                        )),

                  ],
                ),
              ),

      ],
      ),
    ),),);
  }
}

class ArtWorkWidget extends StatelessWidget {
  const ArtWorkWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return QueryArtworkWidget(
      id: context.watch<SongModelProvider>().id,
      type: ArtworkType.AUDIO,
      artworkFit: BoxFit.cover,
      artworkWidth: 200,
      artworkHeight: 200,
      nullArtworkWidget: Icon(Icons.audiotrack,size: 200 ,),
    );
  }
}


