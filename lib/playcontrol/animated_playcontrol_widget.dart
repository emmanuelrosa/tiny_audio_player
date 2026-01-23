import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:provider/provider.dart';
import 'package:tiny_audio_player/playcontrol/playcontrol_widget.dart';

/// Used to show/hide a [PlaycontrolWidget] depending on whether there are
/// audio tracks in the [Playlist].
class AnimatedPlaycontrolWidget extends StatelessWidget {
  final Duration duration;

  const AnimatedPlaycontrolWidget({super.key, required this.duration});

  @override
  Widget build(BuildContext context) => Consumer<Player>(
    builder: (context, player, _) => StreamProvider<Playlist>.value(
      initialData: player.state.playlist,
      value: player.stream.playlist,
      updateShouldNotify: (a, b) => a.medias.length != b.medias.length,
      child: Consumer2<Player, Playlist>(
        builder: (context, player, playlist, _) {
          return AnimatedSwitcher(
            switchInCurve: Curves.ease,
            switchOutCurve: Curves.ease,
            duration: duration,
            transitionBuilder: (Widget child, Animation<double> animation) {
              return SizeTransition(sizeFactor: animation, child: child);
            },
            child: playlist.medias.isEmpty
                ? SizedBox(key: UniqueKey())
                : PlaycontrolWidget(player: player),
          );
        },
      ),
    ),
  );
}
