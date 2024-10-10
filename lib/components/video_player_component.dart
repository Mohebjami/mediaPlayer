// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mediaplyaer/components/control_bar_component.dart';
import 'package:mediaplyaer/components/equalizer/custome_equalizer.dart';
import 'package:video_player/video_player.dart';
import 'package:equalizer_flutter/equalizer_flutter.dart';

class VideoPlayerComponent extends StatefulWidget {
  const VideoPlayerComponent({super.key});

  @override
  _VideoPlayerComponentState createState() => _VideoPlayerComponentState();
}

class _VideoPlayerComponentState extends State<VideoPlayerComponent> {
  late VideoPlayerController _controller;
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;
  bool enableCustomEQ = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    EqualizerFlutter.init(0);
    // Initialize video player
    _controller = VideoPlayerController.asset(
      'assets/media/myVideo.MP4',
    )..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose();
    EqualizerFlutter.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Video player
            Container(
              height: 570,
              color: Colors.black,
              child: _controller.value.isInitialized
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          if (_controller.value.isPlaying) {
                            _controller.pause();
                            _audioPlayer.pause();
                          } else {
                            _controller.play();
                            _audioPlayer.play();
                          }
                          isPlaying = _controller.value.isPlaying;
                        });
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: VideoPlayer(_controller),
                          ),
                          if (!_controller.value.isPlaying)
                            const Icon(
                              Icons.play_circle_fill,
                              size: 100,
                              color: Colors.orange,
                            ),
                        ],
                      ),
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
            // Control bar
            ControlBarComponent(controller: _controller),
            //
            const SizedBox(height: 10.0),

            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
