import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamsavor/pages/animes/animes_homepage.dart';
import 'package:streamsavor/pages/movies/movies_homepage.dart';
import 'package:streamsavor/providers/anime_mode_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool animeMode =
        Provider.of<AnimeModeProvider>(context, listen: true).animeMode;
    return Scaffold(
      appBar: AppBar(
        title: FadeInDown(
          child: Text(
            animeMode ? 'Anime' : 'Movies',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        elevation: 5,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        actions: [
          AnimatedCrossFade(
            firstChild: FadeInDown(
              child: Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).primaryColor,
                ),
                child: const Icon(
                  Icons.movie,
                  color: Colors.white,
                ),
              ),
            ),
            secondChild: FadeInDown(
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  'assets/anime.png',
                  width: 50,
                ),
              ),
            ),
            crossFadeState: animeMode
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
          FadeInRight(
            child: IconButton(
              icon: Icon(
                Icons.swap_horizontal_circle_sharp,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                Provider.of<AnimeModeProvider>(context, listen: false).animeMode =
                    !animeMode;
              },
            ),
          ),
        ],
      ),
      body: animeMode ? const AnimeHomePage() : const MoviesHomePage(),
    );
  }
}
