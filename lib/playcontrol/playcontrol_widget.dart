import 'dart:math';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:provider/provider.dart';

enum _SliderControlType { progress, volume }

/// The container for [Widget]s used to control audio playback.
class PlaycontrolWidget extends StatefulWidget {
  final Player player;
  final double height;

  const PlaycontrolWidget({super.key, required this.player, this.height = 125});

  @override
  State<PlaycontrolWidget> createState() => _PlaycontrolWidgetState();
}

class _PlaycontrolWidgetState extends State<PlaycontrolWidget> {
  _SliderControlType _sliderControlType = .progress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          color: theme.colorScheme.surfaceContainerLow,
          height: widget.height,
          width: constraints.maxWidth,
          child: Center(
            child: SizedBox(
              width: math.min(350.0, constraints.maxWidth),
              child: Column(
                children: [
                  SizedBox(height: 15.0),
                  SizedBox(
                    child: Row(
                      children: [
                        Expanded(
                          child: switch (_sliderControlType) {
                            .progress => _PlaybackProgress(
                              player: widget.player,
                              minHeight: 10.0,
                            ),
                            .volume => _VolumeControl(
                              player: widget.player,
                              minHeight: 10.0,
                            ),
                          },
                        ),
                        SizedBox(width: 5.0),
                        IconButton(
                          onPressed: _handleSliderControlToggle,
                          icon: Icon(switch (_sliderControlType) {
                            .progress => Icons.volume_up_rounded,
                            .volume => Icons.compare_arrows_rounded,
                          }),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.0),
                  StreamProvider<bool>.value(
                    initialData: widget.player.state.playing,
                    value: widget.player.stream.playing,
                    child: Consumer<bool>(
                      builder: (context, playing, _) => Row(
                        mainAxisAlignment: .spaceEvenly,
                        children: [
                          _ControlButton(
                            onPressed: playing ? _handlePrevious : null,
                            icon: Icons.keyboard_double_arrow_left_rounded,
                          ),
                          _AnimatedControlButton(
                            firstIcon: Icons.play_arrow_rounded,
                            secondIcon: Icons.pause_rounded,
                            crossFadeState: playing ? .showSecond : .showFirst,
                            onPressed: _handlePlayOrPause,
                          ),
                          _ControlButton(
                            onPressed: playing ? _handleNext : null,
                            icon: Icons.keyboard_double_arrow_right_rounded,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _handlePlayOrPause() {
    final index = widget.player.state.playlist.index;
    final position = widget.player.state.position;

    return widget.player.state.playing
        ? widget.player.pause()
        : widget.player.jump(index).then((_) => widget.player.seek(position));
  }

  Future<void> _handlePrevious() => widget.player.previous();

  Future<void> _handleNext() => widget.player.next();

  void _handleSliderControlToggle() {
    final _SliderControlType nextState = switch (_sliderControlType) {
      .progress => .volume,
      .volume => .progress,
    };

    setState(() => _sliderControlType = nextState);
  }
}

/// A playback control button.
class _ControlButton extends StatelessWidget {
  final IconData icon;
  final Function()? onPressed;

  const _ControlButton({required this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) =>
      IconButton(onPressed: onPressed, icon: Icon(icon), iconSize: 32);
}

/// A animated playback control button.
class _AnimatedControlButton extends StatelessWidget {
  final IconData firstIcon;
  final IconData secondIcon;
  final CrossFadeState crossFadeState;
  final Duration duration;
  final Function()? onPressed;

  const _AnimatedControlButton({
    required this.firstIcon,
    required this.secondIcon,
    required this.crossFadeState,
    this.duration = const Duration(milliseconds: 250),
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) => AnimatedCrossFade(
    duration: duration,
    firstChild: _ControlButton(onPressed: onPressed, icon: firstIcon),
    secondChild: _ControlButton(onPressed: onPressed, icon: secondIcon),
    crossFadeState: crossFadeState,
  );
}

/// Functions as a progress bar for the playback position, and as a slider to seek.
class _PlaybackProgress extends StatefulWidget {
  final Player player;
  final double? minHeight;

  const _PlaybackProgress({super.key, required this.player, this.minHeight});

  @override
  State<_PlaybackProgress> createState() => _PlaybackProgressState();
}

class _PlaybackProgressState extends State<_PlaybackProgress> {
  double? _adjustmentValue;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => StreamProvider<Duration>.value(
      initialData: widget.player.state.position,
      value: widget.player.stream.position,
      child: Consumer<Duration>(
        builder: (context, position, _) {
          final duration = widget.player.state.duration;
          final percent =
              _adjustmentValue ??
              (duration != Duration.zero && !widget.player.state.completed
                  ? position.inSeconds / duration.inSeconds
                  : 0.0);
          return Slider(
            value: percent,
            min: 0.0,
            max: 1.0,
            onChanged: _adjust,
            onChangeEnd: _seek,
          );
        },
      ),
    ),
  );

  void _adjust(double percent) {
    setState(() => _adjustmentValue = percent);
  }

  Future<void> _seek(double percent) {
    setState(() => _adjustmentValue = null);

    final duration = widget.player.state.duration.inSeconds;
    final boundedPercent = max(0.0, min(1.0, percent));
    final position = Duration(seconds: (boundedPercent * duration).toInt());

    return widget.player.seek(position);
  }
}

/// A volume control widget.
class _VolumeControl extends StatelessWidget {
  final Player player;
  final double? minHeight;

  const _VolumeControl({super.key, required this.player, this.minHeight});

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => StreamProvider<double>.value(
      initialData: player.state.volume,
      value: player.stream.volume,
      child: Consumer<double>(
        builder: (context, volume, _) {
          final theme = Theme.of(context);
          return Slider(
            value: volume,
            min: 0.0,
            max: 100,
            activeColor: theme.colorScheme.tertiary,
            onChanged: _adjust,
          );
        },
      ),
    ),
  );

  Future<void> _adjust(double volume) {
    return player.setVolume(volume);
  }
}
