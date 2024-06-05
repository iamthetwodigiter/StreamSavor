import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:streamsavor/services/movies.dart';
import 'package:streamsavor/services/downloader.dart';
import 'package:streamsavor/pages/video_player.dart';
import 'package:streamsavor/repository/movies_repository.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MovieDetails extends StatefulWidget {
  final String id;
  final String title;
  final String releaseDate;
  const MovieDetails(
      {super.key,
      required this.id,
      required this.title,
      required this.releaseDate});

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  late Box<Movie> favoritesBox;
  String name = '';
  String downloadLink = '';
  Set<Movie> favoriteMovies = {};

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    favoritesBox = Hive.box('movies-fav');
    setState(() {
      favoriteMovies = favoritesBox.values.toSet();
    });
  }

  Future<void> _saveFavorites() async {
    await favoritesBox.putAll(
      Map.fromEntries(
        favoriteMovies.map(
          (movie) => MapEntry(
            movie.id,
            movie,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // if (Hive.isBoxOpen('movies-fav')) {
    //   print('The movies-fav box is open');
    //   favoritesBox.close();
    //   favoritesBox.deleteFromDisk();
    //   print("Box deleted");
    // } else {
    //   print('The movies-fav box is not open');
    // }
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Theme.of(context).primaryColor,
          onPressed: () => {Navigator.pop(context)},
        ),
        actions: [
          IconButton(
            icon: Icon(
              favoriteMovies.any((movie) => movie.id == widget.id)
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () async {
              if (favoriteMovies.any((movie) => movie.id == widget.id)) {
                favoriteMovies.removeWhere((movie) => movie.id == widget.id);
              } else {
                favoriteMovies.add(Movie(
                    id: widget.id,
                    title: widget.title,
                    releaseDate: widget.releaseDate));
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
      body: Center(
        child: FutureBuilder<MovieInfo>(
          future: moviesInfo(widget.id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // String title = snapshot.data!.title;
              name = snapshot.data!.title;
              return ListView(
                children: [
                  FadeInDown(
                    child: Image(
                      image: CachedNetworkImageProvider(snapshot.data!.cover !=
                              'N/A'
                          ? snapshot.data!.cover
                          : 'https://www.gstatic.com/mobilesdk/180227_mobilesdk/storage_rules_zerostate.png'),
                      height: size.height * 0.268,
                      fit: BoxFit.fitWidth,
                      errorBuilder: (context, error, stackTrace) {
                        return SizedBox(
                          height: size.height * 0.268,
                          child: Image.asset('assets/error.png'),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 15),
                  FadeInLeft(
                    child: Text(
                      snapshot.data!.title,
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  FadeInRight(
                    child: Text(
                      snapshot.data!.description,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                  FadeInLeft(
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          color: Color.fromARGB(255, 124, 124, 124),
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          const TextSpan(
                            text: '\nReleased:  ',
                          ),
                          TextSpan(
                            text: snapshot.data!.releaseDate,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
                          ),
                          const TextSpan(
                            text: '\nRatings:  ',
                          ),
                          TextSpan(
                            text: '${snapshot.data!.ratings} ⭐',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
                          ),
                          const TextSpan(
                            text: '\nDuration:  ',
                          ),
                          TextSpan(
                            text: snapshot.data!.duration,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
                          ),
                          const TextSpan(
                            text: '\nGenres:  ',
                          ),
                          TextSpan(
                            text: snapshot.data!.genres,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                          const TextSpan(
                            text: '\nCasts:  ',
                          ),
                          TextSpan(
                            text: snapshot.data!.casts,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                          const TextSpan(
                            text: '\nDirector(s):  ',
                          ),
                          TextSpan(
                            text: snapshot.data!.director,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                          const TextSpan(
                            text: '\nWriter(s):  ',
                          ),
                          TextSpan(
                            text: snapshot.data!.writer,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  FadeInDown(
                    child: ElevatedButton(
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: Colors.black,
                          title: const Text(
                            'Choose a Server',
                            style: TextStyle(
                              color: Color.fromARGB(255, 124, 124, 124),
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          contentTextStyle: const TextStyle(
                            color: Colors.blue,
                            fontSize: 18,
                          ),
                          content: SizedBox(
                            width: 200,
                            height: 150,
                            child: FutureBuilder<ServerData>(
                              future: listServers(snapshot.data!.id),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: SizedBox(
                                      height: 50,
                                      width: 50,
                                      child: CircularProgressIndicator(
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  return Text(
                                    // 'Error: ${snapshot.error}',
                                    'Failed to load servers!!!',
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                } else {
                                  final server = snapshot.data!;
                                  return ListView.builder(
                                    itemCount: server.links.length,
                                    itemBuilder: (context, index) {
                                      final link = server.links;
                                      return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              int x = server.stream!
                                                  .lastIndexOf('/');
                                              String url = server.stream!
                                                      .substring(0, x + 1) +
                                                  link.values.elementAt(index);

                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      DefaultPlayer(
                                                    videoUrl: url,
                                                    subUrl: server.subtitle,
                                                    name: snapshot.data!.name,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Text(
                                              link.keys.elementAt(index),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => {Navigator.pop(context)},
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.black),
                        shadowColor: MaterialStateProperty.all(
                            Theme.of(context).primaryColor),
                        elevation: MaterialStateProperty.all(10),
                        fixedSize: const MaterialStatePropertyAll(
                          Size(60, 15),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.play_arrow_rounded,
                            color: Theme.of(context).primaryColor,
                            size: 30,
                          ),
                          Text(
                            'Play',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  FadeInDown(
                    delay: const Duration(milliseconds: 150),
                    child: ElevatedButton(
                      onPressed: () async {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Download $name Started',
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
                        final temp = await listServers(widget.id);

                        final link = await listStreams(temp.stream!);
                        final downloadLink = temp.stream!.substring(
                                0, temp.stream!.lastIndexOf('/') + 1) +
                            link.values.elementAt(0);
                        downloadFile(
                            downloadLink,
                            '',
                            name,
                            snapshot.data!.cover,
                            temp.subtitle,
                            false,
                            context);
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.black),
                        shadowColor: MaterialStateProperty.all(
                            Theme.of(context).primaryColor),
                        elevation: MaterialStateProperty.all(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.download_rounded,
                            color: Theme.of(context).primaryColor,
                            size: 30,
                          ),
                          Text(
                            'Download',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Text(
                // snapshot.error.toString(),
                'Failed to load data!!',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              );
            } else {
              return CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              );
            }
          },
        ),
      ),
    );
  }
}
