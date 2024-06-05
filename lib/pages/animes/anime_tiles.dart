import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:streamsavor/pages/animes/anime_details.dart';
import 'package:streamsavor/repository/anime_repository.dart';
import 'package:streamsavor/services/animes.dart';

class AnimeTiles extends StatelessWidget {
  final String reqData;
  const AnimeTiles({super.key, required this.reqData});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: SizedBox(
        height: reqData == 'spotlightAnimes'
            ? size.height * 0.2
            : size.height * 0.32,
        child: FutureBuilder<List<AnimeCards>>(
          future: spotlightAnime(reqData),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  if (snapshot.hasData) {
                    final anime = snapshot.data![index];
                    return FadeInUp(
                      duration: Duration(milliseconds: index * 200),
                      delay: Duration(milliseconds: index * 100),
                      child: Container(
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
                                      anime.poster,
                                      maxHeight: (size.height * 0.25).toInt(),
                                    ),
                                    errorBuilder: (context, error, stackTrace) {
                                      return SizedBox(
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
                                anime.name,
                                style: const TextStyle(
                                    // color: Theme.of(context).primaryColor,
                                    color: Color.fromARGB(255, 247, 202, 255),
                                    fontSize: 12,
                                    overflow: TextOverflow.fade),
                                maxLines: 2,
                              ),
                            ],
                          ),
                          onTap: () async {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => AnimeDetails(
                                  id: anime.id,
                                  name: anime.name,
                                  poster: anime.poster,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Scaffold(
                      backgroundColor: Colors.black,
                      body: Center(
                        child: Text(
                          'Failed to load data!!',
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
                      backgroundColor: Colors.black,
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
              );
            } else if (snapshot.hasError) {
              // return Scaffold(body: Text(snapshot.error.toString()));
              return Scaffold(
                backgroundColor: Colors.black,
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
                backgroundColor: Colors.black,
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
