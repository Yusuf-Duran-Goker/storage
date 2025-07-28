// lib/pages/video_player_widget.dart
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:storage/utils/app_colors.dart';

class VideoPlayerWidget extends StatefulWidget {
  const VideoPlayerWidget({super.key});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _videoController;
  late ChewieController _chewieController;
  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    // VideoController'ı asset ile oluştur
    _videoController = VideoPlayerController.asset(
      'assets/video/video2.mp4',
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );

    // Initialize() süresini ölç
    final sw = Stopwatch()..start();
    _videoController.initialize().then((_) {
      sw.stop();


      // Initialize tamamlandı, şimdi ChewieController oluştur
      _chewieController = ChewieController(
        videoPlayerController: _videoController,
        aspectRatio: 16 / 9,
        autoInitialize: false, // manuel initialize yaptık
        autoPlay: true,
        looping: false,
        errorBuilder: (ctx, err) => Center(
          child: Text(err, style: TextStyle(color: Colors.red)),
        ),
      );

      // UI'ı güncelle
      setState(() {
        _isReady = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Player'),
        backgroundColor: AppColors.primary,
      ),
      body: Center(
        child: _isReady
            ? Chewie(controller: _chewieController)
            : const CircularProgressIndicator(),
      ),
    );
  }

  @override
  void dispose() {
    if (_isReady) _chewieController.dispose();
    _videoController.dispose();
    super.dispose();
  }
}
