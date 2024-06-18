import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamsavor/pages/video_player.dart';
import 'package:streamsavor/providers/dark_mode_provider.dart';
import 'package:swipe_to/swipe_to.dart';

class DownloadsPage extends StatefulWidget {
  const DownloadsPage({super.key});

  @override
  State<DownloadsPage> createState() => _DownloadsPageState();
}

class _DownloadsPageState extends State<DownloadsPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    bool isAnime = false;
    File file = File('');
    final coverUrl = <String>[];
    String vttFile = '';
    final name = <String>[];
    String videoFile = '';
    final size = MediaQuery.of(context).size;
    bool darkMode = Provider.of<DarkModeProvider>(context).darkMode;
    List<Directory> getDirectory() {
      late List<Directory> dirs = [];
      final appStorage = Directory(
          '/storage/emulated/0/Android/data/com.thetwodigiter.streamsavor/files/');
      List<FileSystemEntity> files = appStorage.listSync(recursive: true);
      for (FileSystemEntity file in files) {
        if (file.toString().contains('Animes')) {
          setState(() {
            isAnime = true;
          });
        }
        if (file.toString().contains('Directory: ') &&
            file.path != appStorage.path &&
            file.path != '${appStorage.path}Animes') {
          dirs.add(Directory(file.path));
        }
      }
      return dirs;
    }

    Set<File> getFiles(String dir) {
      final fileSet = <File>{};
      List<FileSystemEntity> files = Directory(dir).listSync(recursive: true);
      for (FileSystemEntity file in files) {
        if (file.toString().contains('mp4')) {
          fileSet.add(File(file.path));
        }
      }
      return fileSet;
    }

    Set<File> getvttFiles(String dir) {
      final vttfileSet = <File>{};
      List<FileSystemEntity> files = Directory(dir).listSync(recursive: true);
      for (FileSystemEntity file in files) {
        if (file.toString().contains('vtt')) {
          vttfileSet.add(File(file.path));
        }
      }
      return vttfileSet;
    }

    var dirs = getDirectory();
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 75,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                child: FadeInRight(
                  child: Text(
                    'Downloads',
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
      body: dirs.isNotEmpty
          ? ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: dirs.length,
              itemBuilder: (context, index) {
                if (isAnime) {
                  file = File('${dirs[index].path}/info.txt');
                  coverUrl.add(file.readAsLinesSync().first);
                  name.add(dirs[index].path.split('/').last);
                } else {
                  file = File('${dirs[index].path}/info.txt');
                  coverUrl.add(file.readAsLinesSync().first);
                  vttFile = '${dirs[index].path}/$name.vtt';
                  name.add(dirs[index].path.split('/').last);
                  videoFile = '${dirs[index].path}/$name.mp4';
                }
                return FadeInLeft(
                  delay: Duration(milliseconds: index * 100),
                  child: SwipeTo(
                    iconColor: Colors.red,
                    iconOnLeftSwipe: Icons.delete_rounded,
                    onLeftSwipe: (details) async {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          titleTextStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              fontFamily: 'Poppins'),
                          contentTextStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              fontFamily: 'Poppins'),
                          backgroundColor:
                              Theme.of(context).primaryColor.withAlpha(125),
                          title: const Text('Confirm Delete'),
                          content:
                              const Text('Are you sure you want to delete?'),
                          actions: [
                            ElevatedButton(
                              child: const Text('Cancel'),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            ElevatedButton(
                              child: const Text(
                                'Delete',
                                style: TextStyle(color: Colors.red),
                              ),
                              onPressed: () async {
                                await dirs[index].delete(recursive: true);
                                setState(() {
                                  dirs.removeAt(index);
                                });
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                    child: Container(
                      height: size.height * 0.2,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withAlpha(50),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: isAnime
                            ? InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: ((context) {
                                        var videoFiles =
                                            getFiles(dirs[index].path);
                                        var vttFiles =
                                            getvttFiles(dirs[index].path);
                                        final cover = coverUrl.elementAt(index);
                                        return Scaffold(
                                          key: _scaffoldKey,
                                          appBar: AppBar(
                                            leading: IconButton(
                                              onPressed: () =>
                                                  Navigator.of(context).pop(),
                                              icon: Icon(
                                                Icons.arrow_back_ios_rounded,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                            title: Flexible(
                                              child: Text(
                                                name.elementAt(index),
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontWeight: FontWeight.bold,
                                                  overflow: TextOverflow.fade,
                                                ),
                                                maxLines: 3,
                                              ),
                                            ),
                                          ),
                                          body: ListView.builder(
                                              itemCount: videoFiles.length,
                                              itemBuilder: (context, index) {
                                                return FadeInRight(
                                                  delay: Duration(
                                                      milliseconds:
                                                          index * 100),
                                                  child: SizedBox(
                                                    child: Container(
                                                      margin:
                                                          const EdgeInsets.all(
                                                              10),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      height: size.height * 0.2,
                                                      width: double.infinity,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                          Radius.circular(10),
                                                        ),
                                                        color: Theme.of(context)
                                                            .primaryColor
                                                            .withAlpha(50),
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          ClipRRect(
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                10,
                                                              ),
                                                            ),
                                                            child:
                                                                CachedNetworkImage(
                                                              imageUrl: cover,
                                                              width:
                                                                  size.width *
                                                                      0.25,
                                                            ),
                                                          ),
                                                          Flexible(
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  videoFiles
                                                                      .elementAt(
                                                                          index)
                                                                      .path
                                                                      .split(
                                                                          '/')
                                                                      .last,
                                                                  softWrap:
                                                                      true,
                                                                  maxLines: 2,
                                                                  style:
                                                                      TextStyle(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .primaryColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        20,
                                                                  ),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .fade,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    ElevatedButton(
                                                                      onPressed:
                                                                          () async {
                                                                        Navigator.of(context)
                                                                            .push(
                                                                          MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                DefaultPlayer(
                                                                                  
                                                                              subUrl: vttFiles.isNotEmpty ? vttFiles.elementAt(index).path : '',
                                                                              videoUrl: videoFiles.elementAt(index).path,
                                                                              name: videoFiles.elementAt(index).path.split('/').last,
                                                                            ),
                                                                          ),
                                                                        );
                                                                      },
                                                                      style:
                                                                          ButtonStyle(
                                                                        backgroundColor: MaterialStateProperty.all(darkMode
                                                                            ? Colors.black
                                                                            : Colors.grey[400]),
                                                                        shadowColor:
                                                                            MaterialStateProperty.all(Theme.of(context).primaryColor),
                                                                        elevation:
                                                                            MaterialStateProperty.all(5),
                                                                        fixedSize:
                                                                            const MaterialStatePropertyAll(
                                                                          Size(
                                                                              60,
                                                                              15),
                                                                        ),
                                                                      ),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Icon(
                                                                            Icons.play_arrow_rounded,
                                                                            color:
                                                                                Theme.of(context).primaryColor,
                                                                            size:
                                                                                15,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                        width:
                                                                            10),
                                                                    ElevatedButton(
                                                                      onPressed:
                                                                          () async {
                                                                        File(videoFiles.elementAt(index).path)
                                                                            .delete();
                                                                        File(vttFiles.elementAt(index).path)
                                                                            .delete();

                                                                        final appStorage =
                                                                            File(videoFiles.elementAt(index).path).parent;
                                                                        List<FileSystemEntity>
                                                                            files =
                                                                            Directory(appStorage.path).listSync(recursive: true);
                                                                        if (files.length ==
                                                                            1) {
                                                                          file.delete();
                                                                          file.parent
                                                                              .delete();
                                                                        }

                                                                        if (!isAnime) {
                                                                          setState(
                                                                              () {
                                                                            dirs.removeAt(index);
                                                                          });
                                                                        }
                                                                        setState(
                                                                            () {
                                                                          videoFiles =
                                                                              getFiles(dirs[index].path);
                                                                        });
                                                                        _scaffoldKey
                                                                            .currentState
                                                                            ?.reassemble();
                                                                      },
                                                                      style:
                                                                          ButtonStyle(
                                                                        backgroundColor: MaterialStateProperty.all(darkMode
                                                                            ? Colors.black
                                                                            : Colors.grey[400]),
                                                                        shadowColor:
                                                                            MaterialStateProperty.all(Theme.of(context).primaryColor),
                                                                        elevation:
                                                                            MaterialStateProperty.all(5),
                                                                        fixedSize:
                                                                            const MaterialStatePropertyAll(
                                                                          Size(
                                                                              60,
                                                                              15),
                                                                        ),
                                                                      ),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Icon(
                                                                            Icons.delete_rounded,
                                                                            color:
                                                                                Theme.of(context).primaryColor,
                                                                            size:
                                                                                15,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }),
                                        );
                                      }),
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: size.width * 0.25,
                                      child: CachedNetworkImage(
                                        imageUrl: coverUrl.elementAt(index),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    SizedBox(
                                      width: size.width * 0.5,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              name.elementAt(index),
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: isAnime ? 20 : 25,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          !isAnime
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    ElevatedButton(
                                                      onPressed: () async {
                                                        Navigator.of(context)
                                                            .push(
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                DefaultPlayer(
                                                              subUrl: vttFile,
                                                              videoUrl:
                                                                  videoFile,
                                                              name: name
                                                                  .elementAt(
                                                                      index),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all(Colors
                                                                    .black),
                                                        shadowColor:
                                                            MaterialStateProperty
                                                                .all(Theme.of(
                                                                        context)
                                                                    .primaryColor),
                                                        elevation:
                                                            MaterialStateProperty
                                                                .all(5),
                                                        fixedSize:
                                                            const MaterialStatePropertyAll(
                                                          Size(60, 15),
                                                        ),
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .play_arrow_rounded,
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            size: 15,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    ElevatedButton(
                                                      onPressed: () async {
                                                        File(videoFile)
                                                            .delete();
                                                        File(vttFile).delete();
                                                        file.delete();
                                                        File(videoFile)
                                                            .parent
                                                            .delete();
                                                        setState(() {
                                                          dirs.removeAt(index);
                                                        });
                                                      },
                                                      style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all(Colors
                                                                      .black),
                                                          shadowColor:
                                                              MaterialStateProperty
                                                                  .all(Theme.of(
                                                                          context)
                                                                      .primaryColor),
                                                          elevation:
                                                              MaterialStateProperty
                                                                  .all(5),
                                                          fixedSize:
                                                              const MaterialStatePropertyAll(
                                                                  Size(
                                                                      60, 15))),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .delete_rounded,
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            size: 15,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : const Row(),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Row(
                                children: [
                                  SizedBox(
                                      width: size.width * 0.25,
                                      child: CachedNetworkImage(
                                          imageUrl: coverUrl.elementAt(index))),
                                  const SizedBox(width: 10),
                                  SizedBox(
                                    width: size.width * 0.5,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          name.elementAt(index),
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: isAnime ? 20 : 25,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        !isAnime
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  ElevatedButton(
                                                    onPressed: () async {
                                                      Navigator.of(context)
                                                          .push(
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              DefaultPlayer(
                                                            subUrl: vttFile,
                                                            videoUrl: videoFile,
                                                            name:
                                                                name.elementAt(
                                                                    index),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(
                                                                  Colors.black),
                                                      shadowColor:
                                                          MaterialStateProperty
                                                              .all(Theme.of(
                                                                      context)
                                                                  .primaryColor),
                                                      elevation:
                                                          MaterialStateProperty
                                                              .all(5),
                                                      fixedSize:
                                                          const MaterialStatePropertyAll(
                                                        Size(60, 15),
                                                      ),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .play_arrow_rounded,
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          size: 15,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  ElevatedButton(
                                                    onPressed: () async {
                                                      File(videoFile).delete();
                                                      File(vttFile).delete();
                                                      file.delete();
                                                      File(videoFile)
                                                          .parent
                                                          .delete();
                                                      setState(() {
                                                        dirs.removeAt(index);
                                                      });
                                                    },
                                                    style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all(Colors
                                                                    .black),
                                                        shadowColor:
                                                            MaterialStateProperty
                                                                .all(Theme.of(
                                                                        context)
                                                                    .primaryColor),
                                                        elevation:
                                                            MaterialStateProperty
                                                                .all(5),
                                                        fixedSize:
                                                            const MaterialStatePropertyAll(
                                                                Size(60, 15))),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons.delete_rounded,
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          size: 15,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : const Row(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                );
              },
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: FadeInUp(
                    child: Text(
                      'No Downloads Added!!',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
