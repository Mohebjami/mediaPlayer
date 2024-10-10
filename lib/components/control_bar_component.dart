import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ControlBarComponent extends StatefulWidget {
  final VideoPlayerController controller;

  const ControlBarComponent({super.key, required this.controller});

  @override
  State<ControlBarComponent> createState() => _ControlBarComponentState();
}

class _ControlBarComponentState extends State<ControlBarComponent> {
  double _sliderValue = 0.0;

  @override
  void initState() {
    super.initState();

    // Add a listener to update the slider value in real-time
    widget.controller.addListener(() {
      if (mounted) {
        setState(() {
          _sliderValue = widget.controller.value.position.inSeconds.toDouble();
        });
      }
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return duration.inHours > 0
        ? '$hours:$minutes:$seconds'
        : '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final position = widget.controller.value.position;
    final duration = widget.controller.value.duration;

    return Container(
      color: Colors.black87,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Start timer (current position)
              Text(
                _formatDuration(position),
                style: const TextStyle(color: Colors.white),
              ),
              // Slider for video position
              Expanded(
                child: Slider(
                  value: _sliderValue,
                  onChanged: (value) {
                    setState(() {
                      _sliderValue = value;
                      widget.controller
                          .seekTo(Duration(seconds: value.toInt()));
                    });
                  },
                  activeColor: Colors.orange,
                  inactiveColor: Colors.grey,
                  min: 0,
                  max: duration.inSeconds.toDouble(),
                ),
              ),
              // End timer (total duration)
              Text(
                _formatDuration(duration),
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
          // Control buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.skip_previous, color: Colors.white),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.fast_rewind, color: Colors.white),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(
                  widget.controller.value.isPlaying
                      ? Icons.pause
                      : Icons.play_arrow,
                  color: Colors.white,
                  size: 40,
                ),
                onPressed: () {
                  if (widget.controller.value.isPlaying) {
                    widget.controller.pause();
                  } else {
                    widget.controller.play();
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.fast_forward, color: Colors.white),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.skip_next, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),
          // Bottom control bar (volume and fullscreen)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.volume_up, color: Colors.white),
                  Slider(
                    value: widget.controller.value.volume,
                    activeColor: Colors.orange,
                    inactiveColor: Colors.grey,
                    max: 1,
                    min: 0,
                    onChanged: (value) {
                      setState(() {
                        widget.controller.setVolume(value);
                      });
                    },
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.fullscreen, color: Colors.white),
                onPressed: () {
                  // Handle fullscreen toggle
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
