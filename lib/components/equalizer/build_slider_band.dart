import 'package:flutter/material.dart';
import 'package:equalizer_flutter/equalizer_flutter.dart';

class BuildSliderBand extends StatefulWidget implements PreferredSizeWidget {
  final int freq;
  final int bandId;
  final double? min, max;

  const BuildSliderBand({
    super.key,
    required this.freq,
    required this.bandId,
    required this.min,
    required this.max,
  });

  @override
  State<BuildSliderBand> createState() => _BuildSliderBandState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _BuildSliderBandState extends State<BuildSliderBand> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 250,
            child: FutureBuilder<int>(
              future: EqualizerFlutter.getBandLevel(widget.bandId),
              builder: (context, snapshot) {
                var data = (snapshot.data ?? 0).toDouble();
                return RotatedBox(
                  quarterTurns: 3,
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 1,
                      trackShape: SliderCustomeTrackShape(),
                    ),
                    child: Center(
                      child: Slider(
                        max: widget.max ?? 1.0,
                        min: widget.min ?? 0.0,
                        value: data,
                        onChanged: (value) {
                          setState(() {
                            EqualizerFlutter.setBandLevel(
                                widget.bandId, value.toInt());
                          });
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 15),
          Text('${widget.freq ~/ 1000} Hz', style: TextStyle(color: Colors.white))
        ],
      ),
    );
  }
}

// Custom Slider Track Shape
class SliderCustomeTrackShape extends SliderTrackShape {
  @override
  void paint(
      PaintingContext context,
      Offset offset, {
        required RenderBox parentBox,
        Offset? secondaryOffset, // Optional secondaryOffset parameter
        required SliderThemeData sliderTheme,
        required Animation<double> enableAnimation,
        required TextDirection textDirection,
        required Offset thumbCenter,
        bool isEnabled = false,
        bool isDiscrete = false,
      }) {
    final Paint paint = Paint()
      ..color = sliderTheme.activeTrackColor ?? Colors.blue
      ..style = PaintingStyle.fill;

    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    // Drawing the track
    context.canvas.drawRect(trackRect, paint);
  }

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight ?? 2.0;
    final double trackLeft = offset.dx;
    final double trackTop = (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}