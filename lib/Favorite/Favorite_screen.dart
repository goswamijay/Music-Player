import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

import '../Services/Music_Provider.dart';

class Favorite_Screen extends StatefulWidget {
  const Favorite_Screen({Key? key}) : super(key: key);

  @override
  State<Favorite_Screen> createState() => _Favorite_ScreenState();
}

class _Favorite_ScreenState extends State<Favorite_Screen> {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteItem>(context);
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
            itemCount: favoriteProvider.selectedItem.length,
            itemBuilder: (context, index) {
              return Consumer<FavoriteItem>(builder: (context, value, child) {
                return ListTile(
                    onTap: () {},
                    title: Text(item.data![index].title),
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
}
