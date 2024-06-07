import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamsavor/providers/dark_mode_provider.dart';
import 'package:streamsavor/service/movies.dart';
import 'package:streamsavor/pages/movies/movie_details_page.dart';
import 'package:streamsavor/repository/movies_repository.dart';

class MovieSearchResults extends StatefulWidget {
  final String search;
  const MovieSearchResults({
    super.key,
    required this.search,
  });

  @override
  State<MovieSearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends State<MovieSearchResults> {
  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    bool darkMode = Provider.of<DarkModeProvider>(context).darkMode;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Theme.of(context).primaryColor,
          ),
        ),
        toolbarHeight: 75,
        title: Row(
          children: [
            Expanded(
              child: Container(
                // height: 50,
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                child: TextField(
                  controller: _searchController,
                  style: TextStyle(
                      color: !darkMode ? Theme.of(context).primaryColor : Colors.white,
                    ),
                    decoration: InputDecoration(
                      focusColor: !darkMode ? Theme.of(context).primaryColor : Colors.white,
                      hintText: 'Search',
                      hintStyle: TextStyle(
                      color: !darkMode ? Theme.of(context).primaryColor : Colors.white,
                      ),
                      contentPadding: const EdgeInsets.all(5),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Theme.of(context).primaryColor,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(15),
                        ),
                        borderSide: BorderSide(
                            width: 0.25, color: Theme.of(context).primaryColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(15),
                        ),
                        borderSide: BorderSide(
                            width: 0.25, color: Theme.of(context).primaryColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(15),
                        ),
                        borderSide: BorderSide(
                            width: 0.25, color: Theme.of(context).primaryColor),
                      ),
                    ),
                  onSubmitted: (value) async {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MovieSearchResults(search: value.trimRight()),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
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
                          return FadeInUp(
                            delay: Duration(milliseconds: index * 100),
                            child: Container(
                              width: size.width * 0.4,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
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
                                    Flexible(
                                      child: Text(
                                        movie.title,
                                        style: TextStyle(
                                            color: Theme.of(context).primaryColor,
                                            fontSize: 13.5,
                                            overflow: TextOverflow.fade),
                                        softWrap: true,
                                        maxLines: 3,
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MovieDetails(
                                        id: movie.id,
                                        title: movie.title,
                                        releaseDate: movie.releaseDate!,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Scaffold(
                        body: Center(
                          child: Text(
                            'No Search Result Found',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(
                          color: Theme.of(context).primaryColor,
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
