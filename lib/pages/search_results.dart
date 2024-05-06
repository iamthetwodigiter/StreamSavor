import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:streamsavor/data/movies_data.dart';
import 'package:streamsavor/pages/movie_details.dart';
import 'package:streamsavor/repository/movies.dart';

class SearchResults extends StatefulWidget {
  final String search;
  const SearchResults({
    super.key,
    required this.search,
  });

  @override
  State<SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        toolbarHeight: 75,
        title: Row(
          children: [
            Expanded(
              child: Container(
                // height: 50,
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  decoration: const InputDecoration(
                    focusColor: Colors.white,
                    hintText: 'Search',
                    hintStyle:
                        TextStyle(color: Colors.white, fontFamily: 'Poppins'),
                    contentPadding: EdgeInsets.all(5),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.red,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                      borderSide: BorderSide(width: 0.25, color: Colors.red),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                      borderSide: BorderSide(width: 0.25, color: Colors.red),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                      borderSide: BorderSide(width: 0.25, color: Colors.red),
                    ),
                  ),
                  onSubmitted: (value) async {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchResults(search: value),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: SizedBox(
              height: size.height * 0.35,
              child: SafeArea(
                child: FutureBuilder<List<Movie>>(
                  future: searchMovies(widget.search),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final movies = snapshot.data ?? [];
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: movies.length,
                        itemBuilder: (context, index) {
                          final movie = movies[index];
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Card(
                                    color: Colors.black,
                                    elevation: 1,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image(
                                        image: CachedNetworkImageProvider(
                                          movie.thumb!,
                                          maxHeight:
                                              (size.height * 0.25).toInt(),
                                        ),
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return SizedBox(
                                            height: size.height * 0.268,
                                            child: Image.asset(
                                              'assets/error.png',
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
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MovieDetails(
                                      id: movie.id,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return const Scaffold(
                        backgroundColor: Colors.black,
                        body: Center(
                          child: Text(
                            'No Search Result Found',
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins'),
                          ),
                        ),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.red,
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
