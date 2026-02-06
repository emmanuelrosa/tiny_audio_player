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
  static Future<PlaylistStorageService> init(Player player) async {
    if (kIsWeb) {
      return PlaylistStorageServiceNoop();
    } else {
      return PlaylistStorageServiceHive.init(player);
    }
  }

  /// Returns the persisted playlist.
  Future<List<Media>> getAll();

  /// Replaces any persisted playlist with the provided playlist.
  Future<void> putAll(List<Media> medias);
}

/// Provides persistent storage for a playlist using Hive CE.
class PlaylistStorageServiceHive implements PlaylistStorageService {
  final Box<SerializedMedia> _box;

  PlaylistStorageServiceHive._(Box<SerializedMedia> box) : _box = box;

  /// Initializes the [PlaylistStorageServiceHive].
  /// - Sets up a Hive box.
  /// - Loads the saved playlist into [Player].
  /// - Listens to [Player] playlist changes and saves them.
  static Future<PlaylistStorageServiceHive> init(Player player) async {
    final boxName = '${Constants.namespace}.playlist';
    final directory = await Constants.getDataDir();
    final box = directory == null
        ? await Hive.openBox<SerializedMedia>(boxName)
        : await Hive.openBox<SerializedMedia>(boxName, path: directory.path);
    final playlistStorage = PlaylistStorageServiceHive._(box);
    player.stream.playlist.listen(
      (playlist) => playlistStorage.putAll(playlist.medias),
    );
    final medias = await playlistStorage.getAll();
    await player.open(Playlist(medias), play: false);

    return playlistStorage;
  }

  /// Returns the persisted playlist.
  @override
  Future<List<Media>> getAll() async {
    return _box.values
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
  Future<void> putAll(List<Media> medias) async {
    await _box.clear();
    _box.addAll(
      medias.map(
        (media) => SerializedMedia(
          uri: media.uri,
          title: media.extras?['title'] ?? 'Missing title',
        ),
      ),
    );
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
  Future<void> putAll(List<Media> medias) {
    return Future.value(null);
  }
}
