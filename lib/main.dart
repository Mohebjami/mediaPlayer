import 'package:flutter/material.dart';
import 'components/app_bar_component.dart';
import 'components/video_player_component.dart';

void main() {
  runApp(const VLCPlayerApp());
}

class VLCPlayerApp extends StatelessWidget {
  const VLCPlayerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: VLCPlayer(),
    );
  }
}

class VLCPlayer extends StatelessWidget {
  const VLCPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarComponent(),
      body: Column(
        children: [
          Expanded(
            child: VideoPlayerComponent(),
          ),
        ],
      ),
    );
  }
}
