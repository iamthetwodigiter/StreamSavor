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
      videoPlayerController: VideoPlayerController.networkUrl(
        Uri.parse(widget.videoUrl),
        closedCaptionFile: _loadCaptions(),
      ),
    );
  }

  Future<ClosedCaptionFile> _loadCaptions() async {
    final url = Uri.parse(widget.subUrl);
    try {
      final data = await http.get(url);
      final srtContent = data.body.toString();
      return SubRipCaptionFile(srtContent);
    } catch (e) {
      return SubRipCaptionFile('');
    }
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
            closedCaptionTextStyle: TextStyle(fontSize: 8),
            controls: FlickPortraitControls(),
            videoFit: BoxFit.fitWidth,
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
