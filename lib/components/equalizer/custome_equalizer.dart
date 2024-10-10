import 'package:flutter/material.dart';
import 'package:equalizer_flutter/equalizer_flutter.dart';

class CustomEQ extends StatefulWidget {
  final bool enabled;
  final List<int> bandLevelRange;
  const CustomEQ({
    super.key,
    required this.enabled,
    required this.bandLevelRange,
  });

  @override
  _CustomEQState createState() => _CustomEQState();
}

class _CustomEQState extends State<CustomEQ> {
  late double min, max;
  String? _selectedValue;
  late Future<List<String>> fetchPresets;

  @override
  void initState() {
    super.initState();
    min = widget.bandLevelRange[0].toDouble();
    max = widget.bandLevelRange[1].toDouble();
    fetchPresets = EqualizerFlutter.getPresetNames();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<int>>(
      future: EqualizerFlutter.getCenterBandFreqs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          List<int> frequencies = snapshot.data!;
          // Initialize the bandId
          int bandId = 0;

          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: frequencies.map((freq) {
                  // Pass the current bandId and increment it for the next slider
                  Widget slider = _buildSliderBand(freq, bandId);
                  bandId++;
                  return slider;
                }).toList(),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(10),
                child: _buildPresets(),
              ),
            ],
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Widget _buildSliderBand(int freq, int bandId) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 250,
            child: FutureBuilder<int>(
              future: EqualizerFlutter.getBandLevel(bandId),
              builder: (context, snapshot) {
                var data = snapshot.data?.toDouble() ?? 0.0;
                return RotatedBox(
                  quarterTurns: 1,
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                        trackHeight: 1, trackShape: SliderCustomTrackShape()),
                    child: Center(
                      child: Slider(
                        min: min,
                        max: max,
                        value: data,
                        onChanged: (lowerValue) {
                          setState(() {
                            EqualizerFlutter.setBandLevel(
                                bandId, lowerValue.toInt());
                          });
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Text('${freq ~/ 1000} Hz', style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildPresets() {
    return FutureBuilder<List<String>>(
      future: fetchPresets,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final presets = snapshot.data;
          if (presets!.isEmpty) return const Text('No presets available!');
          return DropdownButtonFormField(
            decoration: const InputDecoration(
              labelText: 'Available Presets',
              border: OutlineInputBorder(),
            ),
            value: _selectedValue,
            onChanged: widget.enabled
                ? (String? value) {
              EqualizerFlutter.setPreset(value!);
              setState(() {
                _selectedValue = value;
              });
            }
                : null,
            items: presets.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          );
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}

class SliderCustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double? trackHeight = sliderTheme.trackHeight;
    final double trackLeft = offset.dx;
    final double trackTop = (parentBox.size.height) / 2;
    const double trackWidth = 230;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight!);
  }
}