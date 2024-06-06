import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamsavor/pages/animes/anime_search_results.dart';
import 'package:streamsavor/pages/movies/movies_search_results_page.dart';
import 'package:streamsavor/providers/anime_mode_provider.dart';
import 'package:streamsavor/providers/dark_mode_provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SearchHistory extends ValueNotifier<List<String>> {
  SearchHistory() : super([]) {
    initSearchHistory();
  }

  void addSearchQuery(String searchQuery) {
    value.add(searchQuery);
    notifyListeners();
    _saveSearchHistory();
  }

  Future<void> initSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final storedSearchHistory = prefs.getStringList('search_history');
    if (storedSearchHistory != null) {
      value = storedSearchHistory;
    }
  }

  Future<void> _saveSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('search_history', value);
  }
}

class SearchHistoryProvider with ChangeNotifier {
  final SearchHistory _searchHistory;

  SearchHistoryProvider(this._searchHistory);

  List<String> get searchHistory => _searchHistory.value;

  void addSearchQuery(String searchQuery) {
    _searchHistory.addSearchQuery(searchQuery);
    notifyListeners();
  }
}

class SearchPage extends StatelessWidget {
  SearchPage({super.key});
  final SearchHistory _searchHistory = SearchHistory();

  @override
  Widget build(BuildContext context) {
    _searchHistory.initSearchHistory();
    return ChangeNotifierProvider(
      create: (context) => SearchHistoryProvider(_searchHistory),
      child: _SearchPage(),
    );
  }
}

class _SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<_SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final searchHistoryProvider = Provider.of<SearchHistoryProvider>(context);
    bool darkMode = Provider.of<DarkModeProvider>(context).darkMode;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 75,
        title: Row(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                child: FadeInDown(
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
                      searchHistoryProvider.addSearchQuery(value.trimRight());
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
      body: Column(
        mainAxisAlignment: searchHistoryProvider.searchHistory.isEmpty ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: [
          searchHistoryProvider.searchHistory.isEmpty
              ? FadeInUp(
                  child: Center(
                    child: Text(
                      'Search your content here',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              : const SizedBox(height: 20),
          Consumer<SearchHistoryProvider>(
            builder: (context, provider, child) {
              return provider.searchHistory.isEmpty
                  ? const SizedBox(height: 0)
                  : Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: provider.searchHistory.length,
                        itemBuilder: (context, index) {
                          return FadeInRight(
                            delay: Duration(milliseconds: index*100),
                            child: ListTile(
                              dense: true,
                              title: Text(
                                provider.searchHistory[index],
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 15,
                                ),
                              ),
                              trailing: IconButton(
                                onPressed: () {
                                  setState(() {
                                    provider.searchHistory.removeAt(index);
                                  });
                                },
                                icon: const Icon(
                                  Icons.cancel_rounded,
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        Provider.of<AnimeModeProvider>(context,
                                                    listen: true)
                                                .animeMode
                                            ? AnimeSearchResult(
                                                search: provider
                                                    .searchHistory[index]
                                                    .trimRight())
                                            : MovieSearchResults(
                                                search: provider
                                                    .searchHistory[index]
                                                    .trimRight()),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    );
            },
          ),
        ],
      ),
    );
  }
}
