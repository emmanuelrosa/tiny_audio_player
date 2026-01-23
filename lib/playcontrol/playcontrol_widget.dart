import 'dart:math';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
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
                          icon: HeroIcon(switch (_sliderControlType) {
                            .progress => HeroIcons.speakerWave,
                            .volume => HeroIcons.arrowsRightLeft,
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
                            icon: HeroIcons.backward,
                          ),
                          _AnimatedControlButton(
                            firstIcon: HeroIcons.play,
                            secondIcon: HeroIcons.pause,
                            crossFadeState: playing ? .showSecond : .showFirst,
                            onPressed: _handlePlayOrPause,
                          ),
                          _ControlButton(
                            onPressed: playing ? _handleNext : null,
                            icon: HeroIcons.forward,
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
  final HeroIcons icon;
  final Function()? onPressed;

  const _ControlButton({required this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) =>
      IconButton(onPressed: onPressed, icon: HeroIcon(icon), iconSize: 32);
}

/// A animated playback control button.
class _AnimatedControlButton extends StatelessWidget {
  final HeroIcons firstIcon;
  final HeroIcons secondIcon;
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
class _PlaybackProgress extends StatelessWidget {
  final Player player;
  final double? minHeight;

  const _PlaybackProgress({super.key, required this.player, this.minHeight});

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => StreamProvider<Duration>.value(
      initialData: player.state.position,
      value: player.stream.position,
      child: Consumer<Duration>(
        builder: (context, position, _) {
          final duration = player.state.duration;
          final percent = duration != Duration.zero && !player.state.completed
              ? position.inSeconds / duration.inSeconds
              : 0.0;
          return GestureDetector(
            onTapUp: (details) => player.state.playing
                ? _seek(details.localPosition.dx / constraints.maxWidth)
                : null,
            child: LinearProgressIndicator(
              value: percent,
              minHeight: minHeight,
            ),
          );
        },
      ),
    ),
  );

  Future<void> _seek(double percent) {
    final duration = player.state.duration.inSeconds;
    final boundedPercent = max(0.0, min(1.0, percent));
    final position = Duration(seconds: (boundedPercent * duration).toInt());

    return player.seek(position);
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
          return GestureDetector(
            onTapUp: (details) =>
                _adjust(details.localPosition.dx / constraints.maxWidth),
            child: LinearProgressIndicator(
              value: volume / 100.0,
              minHeight: minHeight,
              color: theme.colorScheme.tertiary,
            ),
          );
        },
      ),
    ),
  );

  Future<void> _adjust(double percent) {
    final volume = max(0.0, min(1.0, percent)) * 100;
    return player.setVolume(volume);
  }
}
