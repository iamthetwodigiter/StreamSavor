import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:streamsavor/data/movies_data.dart';
import 'package:streamsavor/pages/home_page.dart';
import 'package:streamsavor/pages/movie_details.dart';
import 'package:streamsavor/repository/movies.dart';

class Favorites extends StatefulWidget {
  const Favorites({super.key});

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  @override
  Widget build(BuildContext context) {
    List<String> titles = [];
    List<String> releaseDates = [];
    final size = MediaQuery.of(context).size;
    int currentPage = 1;
    late Box<Movie> favoritesBox = Hive.box('favorites');

    if (favoritesBox.length == 0) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          toolbarHeight: 75,
          title: Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  child: const Text(
                    'Favorites',
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins'),
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.black,
        ),
        body: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                'No Favorites Added!!',
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 25,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black,
          selectedIconTheme: const IconThemeData(color: Colors.red),
          unselectedIconTheme: const IconThemeData(color: Colors.grey),
          iconSize: 30,
          selectedFontSize: 0,
          unselectedFontSize: 0,
          onTap: (value) {
            setState(() {
              currentPage = value;
            });
          },
          currentIndex: currentPage,
          items: [
            BottomNavigationBarItem(
              icon: GestureDetector(
                  onTap: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomePage(),
                      ),
                    );
                  },
                  child: const Icon(Icons.home_rounded)),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: GestureDetector(
                  onTap: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Favorites(),
                      ),
                    );
                  },
                  child: const Icon(Icons.favorite_rounded)),
              label: '',
            ),
          ],
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
                child: const Text(
                  'Favorites',
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins'),
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
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
                      child: FutureBuilder(
                        future:
                            moviesInfo(favoritesBox.values.elementAt(index).id),
                        builder: (context, snapshot) {
                          titles
                              .add(favoritesBox.values.elementAt(index).title);
                          releaseDates.add(favoritesBox.values
                              .elementAt(index)
                              .releaseDate!);
                          if (snapshot.hasData) {
                            return Container(
                              width: size.width * 0.4,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Card(
                                    color: Colors.black,
                                    elevation: 1,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: CachedNetworkImage(
                                          imageUrl: snapshot.data!.cover),
                                    ),
                                  ),
                                  Text(
                                    favoritesBox.values.elementAt(index).title,
                                    style: const TextStyle(
                                        color: Colors.red,
                                        fontSize: 12,
                                        fontFamily: 'Poppins'),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return const CircularProgressIndicator(
                                color: Colors.red);
                          }
                        },
                      ),
                      onTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MovieDetails(
                              id: favoritesBox.values.elementAt(index).id,
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
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedIconTheme: const IconThemeData(color: Colors.red),
        unselectedIconTheme: const IconThemeData(color: Colors.grey),
        iconSize: 30,
        selectedFontSize: 0,
        unselectedFontSize: 0,
        onTap: (value) {
          setState(() {
            currentPage = value;
          });
        },
        currentIndex: currentPage,
        items: [
          BottomNavigationBarItem(
            icon: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.home_rounded)),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
                onTap: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Favorites(),
                    ),
                  );
                },
                child: const Icon(Icons.favorite_rounded)),
            label: '',
          ),
        ],
      ),
    );
  }
}
