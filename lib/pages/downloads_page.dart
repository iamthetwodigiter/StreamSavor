import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:streamsavor/pages/favorites_page.dart';
import 'package:streamsavor/pages/video_player.dart';

class DownloadsPage extends StatefulWidget {
  const DownloadsPage({super.key});

  @override
  State<DownloadsPage> createState() => _DownloadsPageState();
  
}

class _DownloadsPageState extends State<DownloadsPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    int currentPage = 1;

    List<Directory> getDirectory() {
      late List<Directory> dirs = [];
      final appStorage = Directory('/storage/emulated/0/Android/data/com.thetwodigiter.streamsavor/files/');
      List<FileSystemEntity> files = appStorage.listSync(recursive: true);
      for (FileSystemEntity file in files) {
        if (file.toString().contains('Directory: ') &&
            file.path != appStorage.path) {
          dirs.add(Directory(file.path));
        }
      }
      return dirs;
    }

    var dirs = getDirectory();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        toolbarHeight: 75,
        title: Row(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                child: const Text(
                  'Downloads',
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins'),
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.black,
      ),
      body: dirs.isNotEmpty
          ? ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: dirs.length,
              itemBuilder: (context, index) {
                File file = File('${dirs[index].path}/info.txt');
                String coverUrl = file.readAsLinesSync().first;
                String subUrl = file.readAsLinesSync().last;
                String name = dirs[index].path.split('/').last;
                String videoFile = '${dirs[index].path}/$name.mp4';

                return Container(
                  height: size.height * 0.2,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 19, 19, 19),
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Row(
                      children: [
                        Container(
                            width: size.width * 0.25,
                            child: CachedNetworkImage(imageUrl: coverUrl)),
                        const SizedBox(width: 10),
                        Container(
                          width: size.width * 0.5,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                name,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => DefaultPlayer(
                                            subUrl: subUrl,
                                            videoUrl: videoFile,
                                          ),
                                        ),
                                      );
                                    },
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.black),
                                        shadowColor: MaterialStateProperty.all(
                                            Colors.red),
                                        elevation: MaterialStateProperty.all(5),
                                        fixedSize:
                                            const MaterialStatePropertyAll(
                                                Size(60, 15))),
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.play_arrow_rounded,
                                          color: Colors.red,
                                          size: 15,
                                        ),
                                        // Text(
                                        //   'Play',
                                        //   style: TextStyle(
                                        //       color: Colors.red,
                                        //       fontSize: 15,
                                        //       fontFamily: 'Poppins'),
                                        // ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  ElevatedButton(
                                    onPressed: () async {
                                      File(videoFile).delete();
                                      File(subUrl).delete();
                                      file.delete();
                                      File(videoFile).parent.delete();
                                      setState(() {
                                        dirs.removeAt(index);
                                      });
                                    },
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.black),
                                        shadowColor: MaterialStateProperty.all(
                                            Colors.red),
                                        elevation: MaterialStateProperty.all(5),
                                        fixedSize:
                                            const MaterialStatePropertyAll(
                                                Size(60, 15))),
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.delete_rounded,
                                          color: Colors.red,
                                          size: 15,
                                        ),
                                        // Text(
                                        //   'Delete',
                                        //   style: TextStyle(
                                        //       color: Colors.red,
                                        //       fontSize: 15,
                                        //       fontFamily: 'Poppins'),
                                        // ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    'No Downloads Added!!',
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 25,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
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
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: const Icon(Icons.home_rounded)),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
                onTap: () {}, child: const Icon(Icons.download_rounded)),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
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
