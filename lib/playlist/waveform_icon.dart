import 'package:flutter/material.dart';
import 'package:waveform_flutter/waveform_flutter.dart';

/// A widget that looks like an icon with an animated waveform.
/// The waveform is randomly generated.
class WaveformIcon extends StatelessWidget {
  final double? width;
  final double? height;
  final Color? color;

  const WaveformIcon({super.key, this.width, this.height, this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: width ?? 24,
      height: height ?? 24,
      child: AnimatedWaveList(
        stream: createRandomAmplitudeStream(),
        barBuilder: (animation, amplitude) => WaveFormBar(
          amplitude: amplitude,
          animation: animation,
          color: color ?? Colors.cyan,
        ),
      ),
    );
  }
}
