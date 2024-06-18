import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:streamsavor/pages/video_player.dart';
import 'package:streamsavor/providers/dark_mode_provider.dart';
import 'package:streamsavor/repository/anime_repository.dart';
import 'package:streamsavor/repository/movies_repository.dart';
import 'package:streamsavor/service/downloader.dart';
import 'package:streamsavor/service/movies.dart';

class SeriesDetails extends StatefulWidget {
  final String id;
  final String name;
  final String poster;
  const SeriesDetails({
    super.key,
    required this.id,
    required this.name,
    required this.poster,
  });

  @override
  State<SeriesDetails> createState() => _SeriesDetailsState();
}

class _SeriesDetailsState extends State<SeriesDetails> {
  int _currentPage = 0;

  late Box<AnimeCards> favoritesBox;
  Set<AnimeCards> favAnimes = {};

  bool _isExpanded = false;
  int episodeNumber = 0;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    favoritesBox = Hive.box('anime-fav');
    setState(() {
      favAnimes = favoritesBox.values.toSet();
    });
  }

  Future<void> _saveFavorites() async {
    await favoritesBox.putAll(
      Map.fromEntries(
        favAnimes.map(
          (anime) => MapEntry(
            anime.id,
            anime,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    bool darkMode = Provider.of<DarkModeProvider>(context).darkMode;
    // if (Hive.isBoxOpen('anime-fav')) {
    //   print('The anime-fav box is open');
    //   favoritesBox.close();
    //   favoritesBox.deleteFromDisk();
    //   print("Box deleted");
    // } else {
    //   print('The anime-fav box is not open');
    // }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Theme.of(context).primaryColor,
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              favAnimes.any((anime) => anime.id == widget.id)
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () async {
              if (favAnimes.any((anime) => anime.id == widget.id)) {
                favAnimes.removeWhere((anime) => anime.id == widget.id);
              } else {
                favAnimes.add(
                  AnimeCards(
                      id: widget.id, name: widget.name, poster: widget.poster),
                );
              }
              _saveFavorites();
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Added to Favorites ❤️',
                    textAlign: TextAlign.center,
                  ),
                  backgroundColor: Colors.black,
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<SeriesInfo>(
          future: seriesInfo(widget.id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final seriesData = snapshot.data!;
              return Container(
                margin: const EdgeInsets.all(8.0),
                child: FadeInUp(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CachedNetworkImage(
                            imageUrl: seriesData.cover,
                            height: size.height * 0.275,
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            child: FadeInRight(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FadeInDown(
                                    child: Text(
                                      seriesData.title,
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                        color: darkMode
                                            ? const Color.fromARGB(
                                                255, 189, 193, 255)
                                            : Theme.of(context)
                                                .primaryColor
                                                .withAlpha(200),
                                      ),
                                      children: [
                                        const TextSpan(
                                          text: 'Released: ',
                                          style: TextStyle(
                                            color: Colors.blueAccent,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Poppins',
                                            fontSize: 12,
                                          ),
                                        ),
                                        TextSpan(
                                          text: seriesData.releaseDate,
                                          style: const TextStyle(
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                        const TextSpan(
                                          text: '\nCasts: ',
                                          style: TextStyle(
                                            color: Colors.blueAccent,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Poppins',
                                            fontSize: 12,
                                          ),
                                        ),
                                        TextSpan(
                                          text: seriesData.casts,
                                          style: const TextStyle(
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                        const TextSpan(
                                          text: '\nDirector: ',
                                          style: TextStyle(
                                            color: Colors.blueAccent,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Poppins',
                                            fontSize: 12,
                                          ),
                                        ),
                                        TextSpan(
                                          text: seriesData.director,
                                          style: const TextStyle(
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                        const TextSpan(
                                          text: '\nWriter: ',
                                          style: TextStyle(
                                            color: Colors.blueAccent,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Poppins',
                                            fontSize: 12,
                                          ),
                                        ),
                                        TextSpan(
                                          text: seriesData.writer,
                                          style: const TextStyle(
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                        const TextSpan(
                                          text: '\nDuration: ',
                                          style: TextStyle(
                                            color: Colors.blueAccent,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Poppins',
                                            fontSize: 12,
                                          ),
                                        ),
                                        TextSpan(
                                          text: seriesData.duration,
                                          style: const TextStyle(
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                        const TextSpan(
                                          text: '\nRating: ',
                                          style: TextStyle(
                                            color: Colors.blueAccent,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Poppins',
                                            fontSize: 12,
                                          ),
                                        ),
                                        TextSpan(
                                          text: seriesData.ratings,
                                          style: const TextStyle(
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                        const TextSpan(
                                          text: '\nSeasons: ',
                                          style: TextStyle(
                                            color: Colors.blueAccent,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Poppins',
                                            fontSize: 12,
                                          ),
                                        ),
                                        TextSpan(
                                          text: seriesData.seasons == 'N/A'
                                              ? 'N/A'
                                              : seriesData.seasons,
                                          style: const TextStyle(
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      FadeInLeft(
                        child: Text(
                          seriesData.description,
                          style: TextStyle(
                            color: darkMode
                                ? const Color.fromARGB(255, 189, 193, 255)
                                : Theme.of(context).primaryColor.withAlpha(200),
                            fontSize: 15,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      seriesData.seasons != 'N/A'
                          ? Container(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Season',
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22),
                                    textAlign: TextAlign.left,
                                  ),
                                  DropdownButton<int>(
                                    dropdownColor:
                                        const Color.fromARGB(211, 51, 87, 134),
                                    value: _currentPage,
                                    items: List.generate(
                                        int.parse(seriesData.seasons!),
                                        (index) {
                                      return DropdownMenuItem(
                                        value: index,
                                        child: Text(
                                          (index + 1).toString(),
                                          style: TextStyle(
                                            color: darkMode
                                                ? const Color.fromARGB(
                                                    255, 99, 109, 255)
                                                : Colors.blueAccent[100],
                                          ),
                                        ),
                                      );
                                    }),
                                    onChanged: (value) {
                                      setState(() {
                                        _currentPage = value!;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                      seriesData.seasons != 'N/A'
                          ? FutureBuilder(
                              future: getEpisodeInfo(
                                  seriesData.id, _currentPage + 1),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final episodes = snapshot.data!;
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: episodes.length,
                                    itemBuilder: (context, index) {
                                      return FadeInUp(
                                        child: AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 500),
                                          height: _isExpanded &&
                                                  index == episodeNumber
                                              ? size.height * 0.2
                                              : size.height * 0.18,
                                          width: double.infinity,
                                          margin: const EdgeInsets.all(8),
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: darkMode
                                                ? const Color.fromARGB(
                                                    201, 59, 47, 83)
                                                : Theme.of(context)
                                                    .primaryColor
                                                    .withAlpha(150),
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(8),
                                            ),
                                          ),
                                          child: SingleChildScrollView(
                                            child: Row(
                                              children: [
                                                CachedNetworkImage(
                                                  imageUrl: seriesData.cover,
                                                  width: size.width * 0.2,
                                                ),
                                                Flexible(
                                                  child: FadeInRight(
                                                    delay: Duration(
                                                        milliseconds:
                                                            index * 100),
                                                    child: InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          _isExpanded =
                                                              !_isExpanded;
                                                          episodeNumber = index;
                                                        });
                                                      },
                                                      child: Column(
                                                        children: [
                                                          Text(
                                                            'Episode: ${index + 1}',
                                                            style: TextStyle(
                                                              color: darkMode
                                                                  ? const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      119,
                                                                      133,
                                                                      255)
                                                                  : Theme.of(
                                                                          context)
                                                                      .primaryColor,
                                                              fontSize: 18,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 10),
                                                          Text(
                                                            episodes.elementAt(
                                                                index),
                                                            softWrap: true,
                                                            maxLines: 3,
                                                            style: TextStyle(
                                                                color: darkMode
                                                                    ? const Color
                                                                        .fromARGB(
                                                                        255,
                                                                        119,
                                                                        133,
                                                                        255)
                                                                    : Theme.of(
                                                                            context)
                                                                        .primaryColor,
                                                                fontSize: 12),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                          const SizedBox(
                                                              height: 10),
                                                          const SizedBox(
                                                              height: 10),
                                                          _isExpanded &&
                                                                  index ==
                                                                      episodeNumber
                                                              ? Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    FadeInRight(
                                                                      child:
                                                                          TextButton(
                                                                        style:
                                                                            ButtonStyle(
                                                                          backgroundColor:
                                                                              MaterialStateProperty.all(
                                                                            const Color.fromARGB(
                                                                                192,
                                                                                202,
                                                                                221,
                                                                                255),
                                                                          ),
                                                                        ),
                                                                        onPressed:
                                                                            () async {
                                                                          ScaffoldMessenger.of(context)
                                                                              .showSnackBar(
                                                                            SnackBar(
                                                                              backgroundColor: Colors.black87,
                                                                              duration: const Duration(milliseconds: 1000),
                                                                              content: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                children: [
                                                                                  CircularProgressIndicator(
                                                                                    color: Theme.of(context).primaryColor,
                                                                                  ),
                                                                                  const SizedBox(width: 10),
                                                                                  const Text('Loading...')
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          );

                                                                          final streamingLinks = await seriesStreaming(
                                                                              seriesData.id,
                                                                              _currentPage,
                                                                              index + 1);
                                                                          if (streamingLinks.stream ==
                                                                              'none') {
                                                                            ScaffoldMessenger.of(context).showSnackBar(
                                                                              const SnackBar(backgroundColor: Colors.black87, duration: Duration(milliseconds: 2000), content: Text('Failed to load episode!!', style: TextStyle(color: Colors.red),)),
                                                                            );
                                                                          } else {
                                                                            Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(
                                                                                builder: (context) => DefaultPlayer(
                                                                                  videoUrl: streamingLinks.stream,
                                                                                  subUrl: streamingLinks.subtitle,
                                                                                  name: episodes.elementAt(index),
                                                                                ),
                                                                              ),
                                                                            );
                                                                          }
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          'Play',
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.blueAccent[700],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                        width:
                                                                            10),
                                                                    FadeInRight(
                                                                      delay: const Duration(
                                                                          milliseconds:
                                                                              50),
                                                                      child:
                                                                          TextButton(
                                                                        style:
                                                                            ButtonStyle(
                                                                          backgroundColor:
                                                                              MaterialStateProperty.all(
                                                                            const Color.fromARGB(
                                                                                192,
                                                                                202,
                                                                                221,
                                                                                255),
                                                                          ),
                                                                        ),
                                                                        onPressed:
                                                                            () async {
                                                                          ScaffoldMessenger.of(context)
                                                                              .showSnackBar(
                                                                            SnackBar(
                                                                              content: Text(
                                                                                'Download ${episodes.elementAt(index)} Started',
                                                                                style: TextStyle(
                                                                                  color: Theme.of(context).primaryColor,
                                                                                  fontWeight: FontWeight.bold,
                                                                                ),
                                                                                textAlign: TextAlign.center,
                                                                              ),
                                                                              backgroundColor: Colors.black,
                                                                              duration: const Duration(milliseconds: 1500),
                                                                            ),
                                                                          );
                                                                          final streamingLinks = await seriesStreaming(
                                                                              seriesData.id,
                                                                              _currentPage,
                                                                              index + 1);
                                                                          downloadFile(
                                                                              streamingLinks.stream,
                                                                              '',
                                                                              episodes.elementAt(index),
                                                                              seriesData.cover,
                                                                              streamingLinks.subtitle,
                                                                              true,
                                                                              context);
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          'Download',
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.blueAccent[700],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )
                                                              : const Row(),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                } else if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator(
                                    color: Theme.of(context).primaryColor,
                                  );
                                }
                                return Text(
                                  snapshot.error.toString(),
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 20,
                                  ),
                                );
                              },
                            )
                          : Container(),
                    ],
                  ),
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                margin: const EdgeInsets.all(20),
                child: Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              );
            }

            return Text(
              'Unable to Fetch Data!!\n${snapshot.error}',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      ),
    );
  }
}
