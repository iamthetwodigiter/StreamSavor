import 'package:flutter/material.dart';
import 'package:streamsavor/pages/favorites.dart';
import 'package:streamsavor/pages/movie_tiles.dart';
import 'package:streamsavor/pages/search_results.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPage = 0;

  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        toolbarHeight: 75,
        title: Row(
          children: [
            Expanded(
              child: Container(
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
      body: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Latest Launches',style: TextStyle(color: Colors.red, fontFamily: 'Poppins', fontSize: 25, fontWeight: FontWeight.bold),),
            MovieTiles(endpoint: 'new',),
            SizedBox(height: 20),
            Text('Recently Added',style: TextStyle(color: Colors.red, fontFamily: 'Poppins', fontSize: 25, fontWeight: FontWeight.bold),),
            MovieTiles(endpoint: 'add',),
          ],
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
}
