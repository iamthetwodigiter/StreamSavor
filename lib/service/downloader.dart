import 'dart:io';
import 'dart:async';
import 'package:ffmpeg_kit_flutter/ffmpeg_session.dart';
import 'package:ffmpeg_kit_flutter/session_state.dart';
import 'package:flutter/material.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:streamsavor/providers/anime_mode_provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:streamsavor/main.dart';

Future<void> showNotification(
    String title, String body, bool silent, bool vibration) async {
  AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'downloads',
    'Downloads',
    importance: Importance.max,
    priority: Priority.high,
    showWhen: true,
    silent: silent,
    enableVibration: vibration,
    icon: '@mipmap/ic_launcher',
    channelShowBadge: false,
  );
  NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
  );
  await flutterLocalNotificationsPlugin.show(
    0,
    title,
    body,
    platformChannelSpecifics,
  );
}

Future<SessionState> getSessionState(FFmpegSession session) {
  return session.getState();
}

Future<void> downloadFile(String url, String? anime, String name, String cover,
    String subUrl, bool? isAnime, BuildContext context) async {
  bool animeMode =
      Provider.of<AnimeModeProvider>(context, listen: false).animeMode;
  url = animeMode ? url.replaceAll('master', 'index-f1-v1-a1') : url;
  Directory? appStorage = Directory('');

  if (Platform.isIOS) {
    appStorage = await getApplicationDocumentsDirectory();
  }
  if (Platform.isAndroid) {
    final status = await Permission.manageExternalStorage.request();
    if (status.isGranted) {
      appStorage = await getExternalStorageDirectory();
    } else {
      if (await Permission.storage.request().isGranted) {
        appStorage = await getExternalStorageDirectory();
      } else {
        openAppSettings();
      }
    }
  }
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
    int fetchedSize = 0;
    Timer? timer;

    await showNotification('Download Started', 'Downloading $name', true, true);
    FFmpegKit.executeAsync("-i $url -c copy '${playlistFile.path}'")
        .then((session) async {
      timer = Timer.periodic(const Duration(milliseconds: 500), (timer) async {
        if (Directory('${appStorage!.path}/Animes').existsSync()) {
          final state = await getSessionState(session);
          fetchedSize = await playlistFile.length();
          fetchedSize = fetchedSize ~/ 1024;

          if (state == SessionState.completed) {
            showNotification('Download Finished', 'Downloading $name Completed',
                false, false);

            timer.cancel();
          } else if (state == SessionState.running) {
            showNotification(
                'Downloading',
                'Downloading $name ${(fetchedSize / 1024).toString()} MB\nPlease wait till finished..',
                true,
                true);
          }
        }
      });
    });
    final command =
        '-i ${playlistFile.path.replaceAll(name, 'video')} -c:v libx264 -profile:v baseline -c:a copy ${playlistFile.path}';

    await FFmpegKit.execute(command);

    try {
      final vttUrl = File("$filePath/info.txt").readAsLinesSync().last;
      final vttFile = File("$filePath/$name.vtt");
      await HttpClient().getUrl(Uri.parse(vttUrl)).then((request) {
        return request.close();
      }).then((response) async {
        response.pipe(vttFile.openWrite());
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  } catch (e) {
    showNotification('Download Failed', e.toString(), true, true);
    throw Exception(e.toString());
  }
}
