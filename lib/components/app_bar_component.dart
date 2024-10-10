import 'dart:io'; // For platform detection
import 'package:flutter/material.dart';
import 'package:equalizer_flutter/equalizer_flutter.dart';
import 'package:mediaplyaer/components/equalizer/custome_equalizer.dart';

class AppBarComponent extends StatefulWidget implements PreferredSizeWidget {
  const AppBarComponent({
    super.key,
  });

  @override
  State<AppBarComponent> createState() => _AppBarComponentState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AppBarComponentState extends State<AppBarComponent> {
  bool enableCustomEQ = false;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black87,
      title: const Text('Media Player', style: TextStyle(color: Colors.orange)),
      actions: [
        IconButton(
          icon: Image.asset(
            'assets/icons/equalizer.png',
            height: 24,
            width: 24,
            color: Colors.orange,
          ),
          onPressed: () {
            if (!Platform.isIOS) {
              _showEqualizerPopup(context);
            } else {
              // Inform user that equalizer isn't supported on iOS
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Equalizer is not supported on iOS devices.'),
                ),
              );
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.more_vert, color: Colors.orange),
          onPressed: () {},
        ),
      ],
    );
  }

  void _showEqualizerPopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          color: Colors.black87,
          child: Column(
            mainAxisSize: MainAxisSize.min,  // Adjust the height to fit content
            children: [
              // Custom Equalizer Switch
              SwitchListTile(
                title: const Text('Custom Equalizer', style: TextStyle(color: Colors.white)),
                value: enableCustomEQ,
                onChanged: (value) {
                  EqualizerFlutter.setEnabled(value);
                  setState(() {
                    enableCustomEQ = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              FutureBuilder<List<int>>(
                future: EqualizerFlutter.getBandLevelRange(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                    return CustomEQ(
                      enabled: enableCustomEQ,
                      bandLevelRange: snapshot.data!,
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
