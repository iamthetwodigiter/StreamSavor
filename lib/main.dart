import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:streamsavor/pages/landing_page.dart';
import 'package:streamsavor/providers/dark_mode_provider.dart';
import 'package:streamsavor/repository/anime_repository.dart';
import 'package:streamsavor/repository/movies_repository.dart';
import 'package:streamsavor/providers/anime_mode_provider.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
const DarwinInitializationSettings initializationSettingsDarwin =
     DarwinInitializationSettings();

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(MovieAdapter());
  await Hive.openBox<Movie>('movies-fav');
  Hive.registerAdapter(AnimeCardsAdapter());
  await Hive.openBox<AnimeCards>('anime-fav');
  WidgetsFlutterBinding.ensureInitialized();
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
  );

  flutterLocalNotificationsPlugin.initialize(initializationSettings);
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]).then((_) {
  //   runApp(
  //     MultiProvider(
  //       providers: [
  //         ChangeNotifierProvider(create: (context) => AnimeModeProvider()),
  //         ChangeNotifierProvider(create: (context) => DarkModeProvider()),
  //       ],
  //       child: const MyApp(),
  //     ),
  //   );
  // });

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AnimeModeProvider()),
        ChangeNotifierProvider(create: (context) => DarkModeProvider()),
      ],
      child: const MyApp(),
    ),
  );

  await Permission.notification.request();
  if (await Permission.videos.request().isDenied) {
    await Permission.storage.request();
  }
  if (Platform.isAndroid) {
    getExternalStorageDirectory();
  }
  if (Platform.isIOS) {
    var path = await getApplicationDocumentsDirectory();
    await Directory(path.path).create(recursive: true); 
    await Directory('${path.path}/Animes').create(recursive: true); 
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    bool animeMode =
        Provider.of<AnimeModeProvider>(context, listen: true).animeMode;
    bool darkMode =
        Provider.of<DarkModeProvider>(context, listen: true).darkMode;
    return MaterialApp(
      theme: darkMode
          ? ThemeData(
              appBarTheme: const AppBarTheme(
                color: Colors.black,
              ),
              scaffoldBackgroundColor: Colors.black,
              primaryColor: animeMode ? Colors.purpleAccent : Colors.blueAccent,
              fontFamily: 'Poppins',
            )
          : ThemeData(
              appBarTheme: const AppBarTheme(
                color: Colors.white,
              ),
              scaffoldBackgroundColor: Colors.white,
              primaryColor: animeMode ? Colors.deepPurple : Colors.indigoAccent,
              fontFamily: 'Poppins',
            ),
      home: const LandingPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
