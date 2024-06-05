import 'dart:io';
import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';
import 'package:subtitle_wrapper_package/subtitle_wrapper_package.dart';

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
    subtitleController = SubtitleController(
      subtitleUrl: widget.subUrl,
      subtitleType: SubtitleType.webvtt,
    );
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
  }

  @override
  void dispose() {
    _customVideoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
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
          style: TextStyle(color: Theme.of(context).canvasColor),
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
