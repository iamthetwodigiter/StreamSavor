import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:streamsavor/data/movies_data.dart';
import 'package:streamsavor/pages/video_player.dart';
import 'package:streamsavor/repository/movies.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MovieDetails extends StatefulWidget {
  final String id;
  const MovieDetails({
    super.key,
    required this.id,
  });

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  late Box<Movie> favoritesBox;
  Set<Movie> favoriteMovies = {};

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    favoritesBox = Hive.box('favorites');
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
    // if (Hive.isBoxOpen('favorites')) {
    //   print('The favorites box is open');
    //   favoritesBox.close();
    //   favoritesBox.deleteFromDisk();
    //   print("Box deleted");
    // } else {
    //   print('The favorites box is not open');
    // }
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.red,
          onPressed: () => {Navigator.pop(context)},
        ),
        actions: [
          IconButton(
            icon: Icon(
              favoriteMovies.any((movie) => movie.id == widget.id)
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: () async {
              final res = await moviesInfo(widget.id);
              if (favoriteMovies.any((movie) => movie.id == widget.id)) {
                favoriteMovies.removeWhere((movie) => movie.id == widget.id);
              } else {
                favoriteMovies.add(Movie(
                    id: widget.id,
                    title: res.title,
                    releaseDate: res.releaseDate));
              }
              _saveFavorites();
              setState(() {});
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
              return ListView(
                children: [
                  Image(
                    image: CachedNetworkImageProvider(
                        snapshot.data!.cover != 'N/A'
                            ? snapshot.data!.cover
                            : 'https://ibb.co/stHXfxc'),
                    height: size.height * 0.268,
                    fit: BoxFit.fitWidth,
                    errorBuilder: (context, error, stackTrace) {
                      return SizedBox(
                        height: size.height * 0.268,
                        child: Image.asset('assets/error.png'),
                      );
                    },
                  ),
                  const SizedBox(height: 15),
                  Text(
                    snapshot.data!.title,
                    style: const TextStyle(
                        color: Colors.red,
                        fontFamily: 'Poppins',
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    snapshot.data!.description,
                    style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontSize: 12),
                  ),
                  RichText(
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
                              color: Colors.white,
                              fontFamily: 'Poppins',
                              fontSize: 12),
                        ),
                        const TextSpan(
                          text: '\nRatings:  ',
                        ),
                        TextSpan(
                          text: '${snapshot.data!.ratings} ⭐',
                          style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'Poppins',
                              fontSize: 12),
                        ),
                        const TextSpan(
                          text: '\nDuration:  ',
                        ),
                        TextSpan(
                          text: snapshot.data!.duration,
                          style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'Poppins',
                              fontSize: 12),
                        ),
                        const TextSpan(
                          text: '\nGenres:  ',
                        ),
                        TextSpan(
                          text: snapshot.data!.genres,
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins',
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
                            fontFamily: 'Poppins',
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
                            fontFamily: 'Poppins',
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
                            fontFamily: 'Poppins',
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: Colors.black,
                        title: const Text(
                          'Choose a Server',
                          style: TextStyle(
                            color: Color.fromARGB(255, 124, 124, 124),
                            fontSize: 20,
                            fontFamily: 'Poppins',
                          ),
                          textAlign: TextAlign.center,
                        ),
                        contentTextStyle: const TextStyle(
                          color: Colors.blue,
                          fontSize: 18,
                          fontFamily: 'Poppins',
                        ),
                        content: SizedBox(
                          width: 200,
                          height: 150,
                          child: FutureBuilder<List<ServerData>>(
                            future: listServers(snapshot.data!.id),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: CircularProgressIndicator(
                                      color: Colors.red,
                                    ),
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return const Text(
                                  // 'Error: ${snapshot.error}',
                                  'Failed to load data!!!',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 25,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              } else {
                                final servers = snapshot.data;
                                return ListView.builder(
                                  itemCount: servers!.length,
                                  itemBuilder: (context, index) {
                                    final server = servers[index];
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => server
                                                          .stream ==
                                                      null
                                                  ? AlertDialog(
                                                      backgroundColor:
                                                          Colors.black,
                                                      title: const Text(
                                                        'BAD SERVER',
                                                        style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255,
                                                              124,
                                                              124,
                                                              124),
                                                          fontSize: 20,
                                                          fontFamily: 'Poppins',
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () => {
                                                            Navigator.pop(
                                                                context)
                                                          },
                                                          child: const Text(
                                                              'Close'),
                                                        ),
                                                      ],
                                                    )
                                                  : DefaultPlayer(
                                                      videoUrl: server.stream!,
                                                      subUrl: server.subtitle),
                                            ),
                                          ),
                                          child: Text(
                                            server.name.toUpperCase(),
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
                      backgroundColor: MaterialStateProperty.all(Colors.black),
                      shadowColor: MaterialStateProperty.all(Colors.red),
                      elevation: MaterialStateProperty.all(10),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.red,
                          size: 30,
                        ),
                        Text(
                          'Play',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 15,
                              fontFamily: 'Poppins'),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return const Text(
                // snapshot.error.toString(),
                'Failed to load data!!',
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins'),
              );
            } else {
              return const CircularProgressIndicator(
                color: Colors.red,
              );
            }
          },
        ),
      ),
    );
  }
}
