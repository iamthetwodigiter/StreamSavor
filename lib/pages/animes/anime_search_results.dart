import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamsavor/pages/animes/anime_details.dart';
import 'package:streamsavor/providers/dark_mode_provider.dart';
import 'package:streamsavor/repository/anime_repository.dart';
import 'package:streamsavor/service/animes.dart';

class AnimeSearchResult extends StatefulWidget {
  final String search;
  const AnimeSearchResult({super.key, required this.search});

  @override
  State<AnimeSearchResult> createState() => _AnimeSearchResultState();
}

class _AnimeSearchResultState extends State<AnimeSearchResult> {
  final TextEditingController _searchController = TextEditingController();

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
                    color: !darkMode
                        ? Theme.of(context).primaryColor
                        : Colors.white,
                  ),
                  decoration: InputDecoration(
                    focusColor: !darkMode
                        ? Theme.of(context).primaryColor
                        : Colors.white,
                    hintText: 'Search',
                    hintStyle: TextStyle(
                      color: !darkMode
                          ? Theme.of(context).primaryColor
                          : Colors.white,
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
                            AnimeSearchResult(search: value.trimRight()),
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
                child: FutureBuilder<List<SearchAnime>>(
                  future: searchAnime(widget.search),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final animes = snapshot.data ?? [];
                      if (animes.isEmpty) {
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
                      }
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: animes.length,
                        itemBuilder: (context, index) {
                          final anime = animes[index];
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
                                            anime.poster,
                                            maxHeight:
                                                (size.height * 0.23).toInt(),
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
                                        anime.name,
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 13.5,
                                          overflow: TextOverflow.fade,
                                        ),
                                        maxLines: 3,
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
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
