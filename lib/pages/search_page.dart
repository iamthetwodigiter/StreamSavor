import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamsavor/pages/animes/anime_search_results.dart';
import 'package:streamsavor/pages/movies/movies_search_results_page.dart';
import 'package:streamsavor/providers/anime_mode_provider.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        toolbarHeight: 75,
        title: Row(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                child: FadeInDown(
                  child: TextField(
                    controller: searchController,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      focusColor: Colors.white,
                      hintText: 'Search',
                      hintStyle: const TextStyle(
                        color: Colors.white,
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Provider.of<AnimeModeProvider>(
                                      context,
                                      listen: true)
                                  .animeMode
                              ? AnimeSearchResult(search: value.trimRight())
                              : MovieSearchResults(search: value.trimRight()),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: FadeInUp(
          child: Text(
            'Search your content here',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
