import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:provider/provider.dart';
import 'package:streamsavor/providers/anime_mode_provider.dart';

Future<void> downloadFile(String url, String? anime, String name, String cover,
    String subUrl, bool? isAnime, BuildContext context) async {
  bool animeMode =
      Provider.of<AnimeModeProvider>(context, listen: false).animeMode;
  url = animeMode ? url.replaceAll('master', 'index-f1-v1-a1') : url;
  final appStorage = await getExternalStorageDirectory();
  if (animeMode) {
    await Directory('${appStorage!.path}/Animes').create();
    await Directory('${appStorage.path}/Animes/$anime').create();
  } else {
    await Directory('${appStorage!.path}/$name').create();
  }
  try {
    final filePath = animeMode
        ? '${appStorage.path}/Animes/$anime'
        : '${appStorage.path}/$name';
    File infofile = File("$filePath/info.txt");
    infofile.writeAsString('$cover\n$subUrl');
    final playlistFile = File('$filePath/$name.mp4');

    await FFmpegKit.execute("-i $url -c copy '${playlistFile.path}'");
    print('Starting conversion');
    final command = '-i ${playlistFile.path.replaceAll(name, 'video')} -c:v libx264 -profile:v baseline -c:a copy ${playlistFile.path}';
    await FFmpegKit.execute(command);
    print('Conversion Finished');

    // if (vttUrl != 'none') {
    //   final vttFile = File("${appStorage.path}/$name/$name.vtt");
    //   await HttpClient().getUrl(Uri.parse(vttUrl)).then((request) {
    //     return request.close();
    //   }).then((response) async {
    //     response.pipe(vttFile.openWrite());
    //   });
    // }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Download $name completed',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.black,
        duration: const Duration(milliseconds: 1500),
      ),
    );
  } catch (e) {
    throw Exception(e);
  }
}