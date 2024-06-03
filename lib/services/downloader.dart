import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';

Future<void> downloadFile(String url, String name, String vttUrl, String cover, String subUrl, 
    BuildContext context) async {
  final appStorage = await getExternalStorageDirectory();
  await Directory('${appStorage!.path}/$name').create();
  try {
    File infofile = File("${appStorage.path}/$name/info.txt");
    infofile.writeAsString(cover+'\n'+subUrl);
    final playlistFile = File("${appStorage.path}/$name/$name.mp4");
    await FFmpegKit.execute("-i $url -c copy '${playlistFile.path}'");
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