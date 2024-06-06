import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamsavor/providers/dark_mode_provider.dart';
import 'package:streamsavor/services/movies.dart';
import 'package:streamsavor/pages/movies/movie_details_page.dart';

class MovieTiles extends StatelessWidget {
  final String endpoint;
  const MovieTiles({
    super.key,
    required this.endpoint,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    bool darkMode = Provider.of<DarkModeProvider>(context).darkMode;

    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: SizedBox(
        height: size.height * 0.32,
        child: FutureBuilder<List<dynamic>>(
          future: newData(endpoint),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final movie = snapshot.data![index];
                  return FutureBuilder<String?>(
                    future: posterUrl(snapshot.data?[index].imdbId),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        return FadeInUp(
                          duration: Duration(milliseconds: index*100),
                          delay: Duration(milliseconds: index*100),
                          child: Container(
                            width: size.width * 0.4,
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                            child: InkWell(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Card(
                                    color: Colors.black,
                                    elevation: 1,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image(
                                        image: CachedNetworkImageProvider(
                                          snapshot.data == 'N/A'
                                              ? 'https://i.postimg.cc/zvn4QYBV/database-rules-zerostate.png'
                                              : snapshot.data!,
                                          maxHeight: (size.height * 0.23).toInt(),
                                        ),
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return SizedBox(
                                            // height: size.height * 0.2,
                                            child: Image(
                                              image: const AssetImage(
                                                  'assets/error.png'),
                                              height: size.height * 0.15,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  Text(
                                    movie.title,
                                    style: TextStyle(
                                        // color: Theme.of(context).primaryColor,
                                        color: darkMode ?const Color.fromARGB(255, 189, 213, 255) : Theme.of(context).primaryColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.fade),
                                    maxLines: 2,
                                  ),
                                ],
                              ),
                              onTap: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MovieDetails(
                                      id: movie.imdbId,
                                      title: movie.title,
                                      releaseDate: movie.releaseDate,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      }
                      return const SizedBox(width: 0);
                    },
                  );
                },
              );
            } else if (snapshot.hasError) {
              // return Scaffold(body: Text(snapshot.error.toString()));
              return Scaffold(
                body: Center(
                  child: Text(
                    'Failed to load data!!\nPlease reload the app',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            } else {
              return Scaffold(
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        'Loading....',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
