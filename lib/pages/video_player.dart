import 'dart:io';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;

class DefaultPlayer extends StatefulWidget {
  final String subUrl;
  final String videoUrl;

  const DefaultPlayer({
    super.key,
    required this.subUrl,
    required this.videoUrl,
  });

  @override
  State<DefaultPlayer> createState() => _DefaultPlayerState();
}

class _DefaultPlayerState extends State<DefaultPlayer> {
  late FlickManager flickManager;

  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
      videoPlayerController: videoPlayer(),
    );
  }

  VideoPlayerController videoPlayer() {
    if (widget.videoUrl.contains('storage')) {
      return VideoPlayerController.file(
        File(widget.videoUrl),
        closedCaptionFile: _loadCaptions(),
      );
    }
    return VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl),
      closedCaptionFile: _loadCaptions(),
    );
  }

  Future<ClosedCaptionFile> _loadCaptions() async {
    if (widget.subUrl != 'none') {
      final url = Uri.parse(widget.subUrl);
      final data = await http.get(url);
      final srtContent = data.body.toString();
      return WebVTTCaptionFile(srtContent);
    }
    return WebVTTCaptionFile('');
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: ObjectKey(flickManager),
      onVisibilityChanged: (visibility) {
        if (visibility.visibleFraction == 0 && mounted) {
          flickManager.flickControlManager?.autoPause();
        } else if (visibility.visibleFraction == 1) {
          flickManager.flickControlManager?.autoResume();
        }
      },
      child: SizedBox(
        child: FlickVideoPlayer(
          flickManager: flickManager,
          flickVideoWithControls: const FlickVideoWithControls(
            closedCaptionTextStyle: TextStyle(fontSize: 12),
            controls: FlickPortraitControls(),
            videoFit: BoxFit.fitWidth,
            playerErrorFallback: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, color: Colors.red, size: 32),
                  SizedBox(width: 10),
                  Text(
                    'Error Loading!!!',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          flickVideoWithControlsFullscreen: const FlickVideoWithControls(
            controls: FlickLandscapeControls(),
            videoFit: BoxFit.fitWidth,
          ),
        ),
      ),
    );
  }
}
