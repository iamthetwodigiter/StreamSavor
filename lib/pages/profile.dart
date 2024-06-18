import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamsavor/pages/about_me.dart';
import 'package:streamsavor/pages/downloads_page.dart';
import 'package:streamsavor/pages/favorites_page.dart';
import 'package:streamsavor/providers/dark_mode_provider.dart';
import 'package:url_launcher/url_launcher.dart';

void launchBrowser(String url, BuildContext context) async {
  Uri link = Uri.parse(url);
  if (url != 'null') {
    try {
      await launchUrl(link, mode: LaunchMode.platformDefault);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}

class Profile extends StatelessWidget {
  final options = <String>['Downloads', 'Favorites', 'About Me'];
  final iconsList = [
    Icons.download_rounded,
    Icons.favorite_rounded,
    Icons.emoji_emotions_rounded
  ];
  final routes = const [
    DownloadsPage(),
    Favorites(),
    AboutMe(),
  ];

  Profile({super.key});

  @override
  Widget build(BuildContext context) {
    bool darkMode = Provider.of<DarkModeProvider>(context).darkMode;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 75,
        title: Row(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                child: FadeInRight(
                  child: Text(
                    'Profile',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(child: Container()),
          ListView.builder(
            shrinkWrap: true,
            itemCount: options.length + 1,
            itemBuilder: (context, index) {
              return FadeInLeft(
                delay: Duration(milliseconds: index * 100),
                child: ListTile(
                  title: InkWell(
                    onTap: () {
                      if (index < options.length) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => routes[index],
                          ),
                        );
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                            Theme.of(context).primaryColor.withOpacity(0.200),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      height: 75,
                      child: index < options.length
                          ? Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Icon(
                                    iconsList[index],
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  options[index],
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Text(
                                    'Is it Dark already??',
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'No',
                                      style: TextStyle(
                                        // color: Colors.amber[700],
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: !darkMode
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        fontSize: !darkMode ? 18 : 15,
                                      ),
                                    ),
                                    Switch(
                                      activeTrackColor:
                                          Theme.of(context).primaryColor,
                                      thumbColor: MaterialStateProperty.all(
                                          Colors.transparent),
                                      inactiveTrackColor: Colors.grey[400],
                                      thumbIcon: MaterialStateProperty.all(
                                        !darkMode
                                            ? Icon(
                                                Icons.wb_sunny_rounded,
                                                // color: Colors.yellowAccent[700],
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              )
                                            : Icon(
                                                Icons.dark_mode_rounded,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                      ),
                                      value: darkMode,
                                      onChanged: (value) {
                                        Provider.of<DarkModeProvider>(context,
                                                listen: false)
                                            .toggleDarkMode();
                                      },
                                    ),
                                    Text(
                                      'Yes',
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: darkMode
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        fontSize: darkMode ? 18 : 15,
                                      ),
                                    ),
                                    const Padding(
                                        padding: EdgeInsets.only(right: 15)),
                                  ],
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              );
            },
          ),
          Flexible(child: Container()),
          Column(
            children: [
              Text(
                'App version : 4.0.0',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Created with ",
                      style: TextStyle(
                          fontSize: 12,
                          color: darkMode
                              ? Theme.of(context).primaryColor
                              : Colors.black)),
                  Icon(Icons.favorite, color: Theme.of(context).primaryColor),
                  Text(" by",
                      style: TextStyle(
                          fontSize: 12,
                          color: darkMode
                              ? Theme.of(context).primaryColor
                              : Colors.black)),
                  TextButton(
                      onPressed: () {
                        launchBrowser(
                            'https://www.github.com/iamthetwodigiter', context);
                      },
                      child: Text('thetwodigiter',
                          style: TextStyle(
                              fontSize: 12, color: Colors.redAccent[400])))
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
