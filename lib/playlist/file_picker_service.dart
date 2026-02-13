import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:media_kit/media_kit.dart';
import 'package:path/path.dart' as path;
import 'package:tiny_audio_player/playlist/media_builder.dart';

/// Handles prompting the user for one or more files to add to the playlist,
/// and adds the files to the playlist.
class FilePickerService {
  final Player player;

  const FilePickerService(this.player);

  static const allowedExtensions = [
    "mp3",
    "m4a",
    "aac",
    "flac",
    "ogg",
    "oga",
    "opus",
    "wma",
    "wav",
    "aiff",
    "aifc",
    "au",
    "mka",
    "ac3",
    "dts",
    "ape",
    "mac",
    "w64",
    "sd2",
    "irca",
    "pvf",
    "xi",
    "sds",
    "avr",
    "mkv",
    "mka",
    "mks",
    "ogg",
    "ogm",
    "avi",
    "wav",
    "mp4",
    "mov",
  ];

  Future<void> pickFiles(BuildContext context, Player player) async {
    if (context.mounted) {
      _showLoaderOverlay(context);
    }

    final result = await FilePicker.platform.pickFiles(
      dialogTitle: 'Add audio files',
      allowMultiple: true,
      type: .custom,
      allowedExtensions: FilePickerService.allowedExtensions,
    );

    final medias = result == null
        ? <Media>[]
        : await Future.wait(
            List.generate(result.files.length, (index) {
              final file = result.files[index];
              final name = result.names[index] ?? file.name;

              return file.bytes == null
                  ? MediaBuilder.fromPathString(
                      filePath: file.path!,
                      volume: player.state.volume,
                    )
                  : MediaBuilder.fromBytes(
                      bytes: file.bytes!,
                      name: name,
                      volume: player.state.volume,
                    );
            }),
          );

    if (context.mounted) {
      await _hideLoaderOverlay(context);
    }

    for (final media in medias) {
      if (player.state.playlist.medias.contains(media)) {
        /* Currently, I'm unable to add the same media more than once to the playlist.
         * This is because I need a unique ID for each media to make [ReorderableListView] work,
         * and I don't have a way to get such an ID into [Media] on the web.
         */
        continue;
      } else {
        await player.add(media);
      }
    }
  }

  void _showLoaderOverlay(BuildContext context) {
    if (kIsWeb) {
      context.loaderOverlay.show();
    }
  }

  Future<void> _hideLoaderOverlay(BuildContext context) async {
    if (kIsWeb) {
      await Future.delayed(Duration(milliseconds: 500));

      if (context.mounted) {
        context.loaderOverlay.hide();
      }
    }
  }
}
