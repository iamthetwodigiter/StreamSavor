import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:streamsavor/pages/animes/anime_details.dart';
import 'package:streamsavor/repository/anime_repository.dart';
import 'package:streamsavor/pages/movies/movie_details_page.dart';
import 'package:streamsavor/repository/movies_repository.dart';
import 'package:streamsavor/services/movies.dart';

class Favorites extends StatefulWidget {
  const Favorites({super.key});

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  late Box<Movie> favoritesBox = Hive.box('movies-fav');
  late Box<AnimeCards> animeBox = Hive.box('anime-fav');
  late List<String> moviesThumb = [];

  @override
  void initState() {
    super.initState();
    _fetchPosterUrls();
  }

  Future<void> _fetchPosterUrls() async {
    if (favoritesBox.isNotEmpty) {
      for (int i = 0; i < favoritesBox.length; i++) {
        final x = await moviesInfo(favoritesBox.values.elementAt(i).id);
        moviesThumb.add(x.cover);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    if (favoritesBox.length == 0 && animeBox.length == 0) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          toolbarHeight: 75,
          title: Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  child: FadeInRight(
                    child: Text(
                      'Favorites',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.black,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: FadeInUp(
                child: Text(
                  'No Favorites Added!!',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return FutureBuilder(
        future: Future.delayed(const Duration(milliseconds: 900)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            );
          }

          return Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              toolbarHeight: 75,
              title: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 10),
                      child: FadeInRight(
                        child: Text(
                          'Favorites',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.black,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  FadeInLeft(
                    child: Text(
                      'Movies',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  FadeInRight(
                    child: SizedBox(
                      height: size.height * 0.35,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: favoritesBox.length,
                        itemBuilder: (context, index) {
                          return Container(
                            width: size.width * 0.4,
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                            child: Column(
                              children: [
                                InkWell(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              moviesThumb.elementAt(index),
                                              height: size.height * 0.25,
                                          placeholder: (context, url) {
                                            return const Center(
                                                child:
                                                    CircularProgressIndicator());
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        favoritesBox.values
                                            .elementAt(index)
                                            .title,
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize: 12,
                                            overflow: TextOverflow.fade),
                                        softWrap: true,
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                  onTap: () async {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MovieDetails(
                                          id: favoritesBox.values
                                              .elementAt(index)
                                              .id,
                                          title: favoritesBox.values
                                              .elementAt(index)
                                              .title,
                                          releaseDate: favoritesBox.values
                                              .elementAt(index)
                                              .releaseDate!,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  FadeInUp(
                    child: Text(
                      'Anime',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  FadeInDown(
                    child: SizedBox(
                      height: size.height * 0.32,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: animeBox.length,
                        itemBuilder: (context, index) {
                          return Container(
                            width: size.width * 0.375,
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                            child: Column(
                              children: [
                                InkWell(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        child: CachedNetworkImage(
                                          imageUrl: animeBox.values
                                              .elementAt(index)
                                              .poster,
                                              height: size.height * 0.25,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        animeBox.values.elementAt(index).name,
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize: 12,
                                            overflow: TextOverflow.fade),
                                        softWrap: true,
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                  onTap: () async {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AnimeDetails(
                                          id: animeBox.values
                                              .elementAt(index)
                                              .id,
                                          name: animeBox.values
                                              .elementAt(index)
                                              .name,
                                          poster: animeBox.values
                                              .elementAt(index)
                                              .poster,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
