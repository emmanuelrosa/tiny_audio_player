import 'package:flutter/foundation.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:media_kit/media_kit.dart';
import 'package:tiny_audio_player/constants.dart';

/// A minimal serializable version of MediaKit's [Media].
class SerializedMedia {
  final String uri;
  final String title;

  const SerializedMedia({required this.uri, required this.title});
}

/// Provides storage for a playlist.
/// No persistent storage on Web.
abstract class PlaylistStorageService {
  factory PlaylistStorageService.init() {
    if (kIsWeb) {
      return PlaylistStorageServiceNoop();
    } else {
      return PlaylistStorageServiceHive();
    }
  }

  /// Returns the persisted playlist.
  Future<List<Media>> getAll();

  /// Replaces any persisted playlist with the provided playlist.
  void putAll(List<Media> medias);
}

/// Provides persistent storage for a playlist using Hive CE.
class PlaylistStorageServiceHive implements PlaylistStorageService {
  late Future<Box<SerializedMedia>> _futureBox;

  PlaylistStorageServiceHive() {
    final boxName = '${Constants.namespace}.playlist';

    _futureBox = Constants.getDataDir().then((directory) {
      if (directory == null) {
        return Hive.openBox(boxName);
      } else {
        return Hive.openBox(boxName, path: directory.path);
      }
    });
  }

  /// Returns the persisted playlist.
  @override
  Future<List<Media>> getAll() async {
    final box = await _futureBox;

    return box.values
        .map(
          (serializedMedia) => Media(
            serializedMedia.uri,
            extras: {'title': serializedMedia.title},
          ),
        )
        .toList();
  }

  /// Replaces any persisted playlist with the provided playlist.
  @override
  void putAll(List<Media> medias) {
    _futureBox.then((box) async {
      await box.clear();
      box.addAll(
        medias.map(
          (media) => SerializedMedia(
            uri: media.uri,
            title: media.extras?['title'] ?? 'Missing title',
          ),
        ),
      );
    });
  }
}

/// Provides no-op storage for a playlist.
/// This implementation doesn't store anything.
class PlaylistStorageServiceNoop implements PlaylistStorageService {
  /// Returns the persisted playlist.
  @override
  Future<List<Media>> getAll() => Future.value([]);

  /// Replaces any persisted playlist with the provided playlist.
  @override
  void putAll(List<Media> medias) {}
}
