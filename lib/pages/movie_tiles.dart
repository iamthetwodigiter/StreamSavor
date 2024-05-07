import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:streamsavor/data/movies_data.dart';
import 'package:streamsavor/pages/movie_details.dart';

class MovieTiles extends StatelessWidget {
  final String endpoint;
  const MovieTiles({
    super.key,
    required this.endpoint,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: SizedBox(
        height: size.height * 0.28,
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
                        return Container(
                          width: size.width * 0.4,
                          margin: const EdgeInsets.symmetric(horizontal: 10),
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
                                        maxHeight: (size.height * 0.2).toInt(),
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
                                  style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                      fontFamily: 'Poppins'),
                                ),
                              ],
                            ),
                            onTap: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MovieDetails(
                                    id: movie.imdbId,
                                  ),
                                ),
                              );
                            },
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
              return const Scaffold(
                backgroundColor: Colors.black,
                body: Center(
                  child: Text(
                    'Failed to load data!!\nPlease Refresh',
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins'),
                  ),
                ),
              );
            } else {
              return const Scaffold(
                backgroundColor: Colors.black,
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        'Loading....',
                        style: TextStyle(
                          color: Colors.red,
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
