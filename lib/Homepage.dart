import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:music_player_flutter/Favorite/Favorite_screen.dart';
import 'package:music_player_flutter/Playlist/Playlist_Screen.dart';

import 'allsong_screen/allscreen_screen.dart';

class homepage extends StatefulWidget {
  const homepage({Key? key}) : super(key: key);

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: CustomScrollView(slivers: [
          SliverAppBar(
            leading: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.search, color: Colors.black)),
            title: const Center(
                child: Text.rich(TextSpan(
                    text: "Music",
                    style: TextStyle(color: Colors.black),
                    children: [
                  TextSpan(
                      text: ' Player',
                      style: TextStyle(
                          color: Color(0xFF8731FF), fontWeight: FontWeight.w400))
                ]))),
            actions: [
              IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.info_outline, color: Colors.black))
            ],
            bottom: TabBar(
              indicatorSize: TabBarIndicatorSize.label,
              indicatorColor: Colors.grey,
              labelColor: Color(0xFF8731FF),
              unselectedLabelColor: Colors.black,
              indicator: const BoxDecoration(
                  border:
                      Border(bottom: BorderSide(width: 3, color:Color(0xFF8731FF)))),
              tabs: [
                Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.music_note, size: 18),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "All Songs",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(PhosphorIcons.heart_fill, size: 18),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Favorite",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(PhosphorIcons.playlist, size: 18),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Playlist",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  height: size.height,
                  width: size.width,
                  child: Column(
                    children: const [
                      Flexible(
                          child: TabBarView(
                        physics: BouncingScrollPhysics(),
                        children: [
                          allsong(),
                          Favorite_Screen(),
                          Playlist_screen(),
                        ],
                      ))
                    ],
                  ),
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
