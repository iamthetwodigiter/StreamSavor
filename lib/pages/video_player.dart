import 'dart:io';
import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamsavor/providers/dark_mode_provider.dart';
import 'package:subtitle_wrapper_package/subtitle_wrapper_package.dart';
import 'package:wakelock/wakelock.dart';

class DefaultPlayer extends StatefulWidget {
  final String subUrl;
  final String videoUrl;
  final String name;

  const DefaultPlayer({
    super.key,
    required this.subUrl,
    required this.videoUrl,
    required this.name,
  });

  @override
  State<DefaultPlayer> createState() => _DefaultPlayerState();
}

class _DefaultPlayerState extends State<DefaultPlayer> {
  late VideoPlayerController _videoPlayerController;
  late CustomVideoPlayerController _customVideoPlayerController;
  final CustomVideoPlayerSettings _customVideoPlayerSettings =
      const CustomVideoPlayerSettings(showSeekButtons: true);
  late SubtitleController subtitleController;

  @override
  void initState() {
    super.initState();
    if (widget.subUrl.contains('storage')) {
      final vttfile = File(widget.subUrl);
      final vttfilecontent = vttfile.readAsStringSync();
      subtitleController = SubtitleController(
        subtitlesContent: vttfilecontent,
        subtitleType: SubtitleType.webvtt,
      );
    } else {
      subtitleController = SubtitleController(
        subtitleUrl: widget.subUrl,
        subtitleType: SubtitleType.webvtt,
      );
    }

    if (widget.videoUrl.contains('storage')) {
      _videoPlayerController = VideoPlayerController.file(
        File(widget.videoUrl),
      )..initialize().then(
          (value) => setState(() {}),
        );
    } else {
      _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoUrl),
      )..initialize().then(
          (value) => setState(() {}),
        );
    }
    _customVideoPlayerController = CustomVideoPlayerController(
      context: context,
      videoPlayerController: _videoPlayerController,
      customVideoPlayerSettings: _customVideoPlayerSettings,
    );
    _videoPlayerController.addListener(_onVideoPlayerControllerUpdate);
  }

  @override
  void dispose() {
    _customVideoPlayerController.dispose();
    _videoPlayerController.removeListener(_onVideoPlayerControllerUpdate);
    super.dispose();
  }

  void _onVideoPlayerControllerUpdate() {
    if (_videoPlayerController.value.isPlaying) {
      Wakelock.enable();
    } else {
      Wakelock.disable();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: Navigator.of(context).pop,
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Theme.of(context).primaryColor,
          ),
        ),
        title: Text(
          widget.name,
          style: TextStyle(
            color: Provider.of<DarkModeProvider>(context).darkMode
                ? Colors.white
                : Theme.of(context).primaryColor,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            SubtitleWrapper(
              videoPlayerController: _videoPlayerController,
              subtitleController: subtitleController,
              subtitleStyle: const SubtitleStyle(
                textColor: Colors.white,
                fontSize: 12,
                hasBorder: true,
                position: SubtitlePosition(bottom: 0),
              ),
              videoChild: CustomVideoPlayer(
                customVideoPlayerController: _customVideoPlayerController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
