import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:streamsavor/pages/landing_page.dart';
import 'package:streamsavor/repository/anime_repository.dart';
import 'package:streamsavor/repository/movies_repository.dart';
import 'package:streamsavor/providers/anime_mode_provider.dart';
void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(MovieAdapter());
  await Hive.openBox<Movie>('movies-fav');
  Hive.registerAdapter(AnimeCardsAdapter());
  await Hive.openBox<AnimeCards>('anime-fav');
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(
      ChangeNotifierProvider(
        create: (context) => AnimeModeProvider(),
        child: const MyApp(),
      ),
    );
  });
  await getExternalStorageDirectory();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    bool animeMode =
        Provider.of<AnimeModeProvider>(context, listen: true).animeMode;
    return MaterialApp(
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
            color: Colors.black,
          ),
          primaryColor: animeMode ? Colors.purple : Colors.blueAccent,
          fontFamily: 'Poppins'),
      home: const LandingPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
