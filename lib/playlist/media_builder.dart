import 'dart:typed_data';

import 'package:media_kit/media_kit.dart';
import 'package:path/path.dart' as path;

/// Provides various ways to create a [Player] [Media].
class MediaBuilder {
  /// Creates the [Media] extras [Map].
  static Map<String, dynamic> createExtras({
    required String title,
    double volume = 100.0,
  }) => {'title': title, 'volume': volume};

  /// Creates a [Media] from a file path.
  static Future<Media> fromPathString({
    required String filePath,
    double volume = 100.0,
  }) {
    final extras = _createExtrasFromFile(name: filePath, volume: volume);

    return Future.value(
      Media(path.toUri(path.normalize(filePath)).toString(), extras: extras),
    );
  }

  /// Creates a [Media] from a byte array.
  static Future<Media> fromBytes({
    required Uint8List bytes,
    required String name,
    double volume = 100.0,
  }) async {
    final extras = _createExtrasFromFile(name: name, volume: volume);
    final media = await Media.memory(bytes);

    return Future.value(Media(media.uri, extras: extras));
  }

  static Map<String, dynamic> _createExtrasFromFile({
    required String name,
    double volume = 100.0,
  }) =>
      createExtras(title: path.basenameWithoutExtension(name), volume: volume);
}
