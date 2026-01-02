import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:heroicons/heroicons.dart';
import 'package:media_kit/media_kit.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';
import 'package:tiny_audio_player/playlist/waveform_icon.dart';

class PlaylistListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Player>(
      builder: (context, player, _) => StreamBuilder<Playlist>(
        initialData: player.state.playlist,
        stream: player.stream.playlist,
        builder: (context, snapshot) {
          final theme = Theme.of(context);
          final medias = snapshot.hasError
              ? <Media>[]
              : snapshot.requireData.medias;

          if (medias.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (kIsWeb)
                  Card.filled(
                    color: theme.colorScheme.tertiaryContainer,
                    margin: EdgeInsetsGeometry.only(bottom: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: LayoutBuilder(
                        builder: (context, constraints) => SizedBox(
                          width: min(350, constraints.maxWidth),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info,
                                color: theme.colorScheme.onTertiaryContainer,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Audio files need to be loaded into memory.\nAvoid adding large audio files.',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  color: theme.colorScheme.onTertiaryContainer,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                Text(
                  'Your playlist is empty.',
                  style: theme.textTheme.bodyLarge,
                ),
                Text(
                  'To get started, add one or more audio files.',
                  style: theme.textTheme.bodyLarge,
                ),
              ],
            );
          }

          final playlist = snapshot.requireData;

          return LayoutBuilder(
            builder: (context, constraints) => ReorderableListView.builder(
              buildDefaultDragHandles: false,
              onReorder: player.move,
              itemCount: medias.length,
              itemBuilder: (context, index) {
                final theme = Theme.of(context);
                final isSelected = playlist.index == index;
                final media = medias[index];
                final key = ValueKey(media);
                final reorderUsingDragHandle = constraints.maxWidth > 700;
                final removeUsingSlidable = constraints.maxWidth < 1440;
                final defaultLeadingIcon = const HeroIcon(HeroIcons.playCircle);
                final leadingIcon = isSelected
                    ? StreamBuilder<bool>(
                        stream: player.stream.playing,
                        initialData: player.state.playing,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return defaultLeadingIcon;
                          }

                          /* For some reason, sometimes the player is in a playing state,
                           * yet it's not actually playing audio.
                           * Not only is there nothing audible, the position and duration
                           * remain at zero.
                           */
                          final isPlaying = snapshot.requireData;
                          if (isPlaying) {
                            return WaveformIcon(
                              color: theme.colorScheme.onPrimaryContainer,
                            );
                          } else {
                            return player.state.position == Duration.zero ||
                                    player.state.completed
                                ? defaultLeadingIcon
                                : const HeroIcon(HeroIcons.play);
                          }
                        },
                      )
                    : defaultLeadingIcon;
                final tile = GestureDetector(
                  onTap: () => _handleTap(player, isSelected, index),
                  child: ListTile(
                    title: Text(path.basenameWithoutExtension(media.uri)),
                    leading: leadingIcon,
                    trailing: reorderUsingDragHandle
                        ? SizedBox(
                            width: removeUsingSlidable ? 28 : 80,
                            child: Row(
                              children: [
                                ReorderableDragStartListener(
                                  index: index,
                                  enabled: medias.length > 1,
                                  child: const Icon(Icons.drag_handle),
                                ),
                                if (!removeUsingSlidable) SizedBox(width: 15),
                                if (!removeUsingSlidable)
                                  IconButton(
                                    color: theme.colorScheme.error,
                                    onPressed: () =>
                                        _handleRemove(player, index),
                                    icon: Icon(Icons.delete),
                                  ),
                              ],
                            ),
                          )
                        : null,
                  ),
                );
                final card = Card(
                  color: isSelected ? theme.colorScheme.primaryContainer : null,
                  margin: const EdgeInsetsGeometry.all(0),
                  child: tile,
                );
                final child = reorderUsingDragHandle
                    ? card
                    : ReorderableDelayedDragStartListener(
                        index: index,
                        enabled: medias.length > 1,
                        child: card,
                      );
                return removeUsingSlidable
                    ? Slidable(
                        key: key,
                        startActionPane: ActionPane(
                          motion: const BehindMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (_) => _handleRemove(player, index),
                              backgroundColor: theme.colorScheme.errorContainer,
                              foregroundColor:
                                  theme.colorScheme.onErrorContainer,
                              icon: Icons.delete,
                            ),
                          ],
                        ),
                        child: child,
                      )
                    : Container(key: key, child: child);
              },
            ),
          );
        },
      ),
    );
  }

  Future<void> _handleRemove(Player player, int index) => player.remove(index);

  Future<void> _handleTap(Player player, bool isSelected, int index) {
    if (isSelected) {
      /* NOTICE: [player.play()] nor [player.playOrPause()] work.
       * I think it's because I'm using a playlist, which may require
       * a [player.jump()] to start the initial playback.
       */
      return player.state.playing ? player.pause() : player.jump(index);
    } else {
      return player.jump(index);
    }
  }
}
