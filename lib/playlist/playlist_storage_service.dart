import 'package:flutter/foundation.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:media_kit/media_kit.dart';
import 'package:tiny_audio_player/constants.dart';
import 'package:tiny_audio_player/playlist/media_builder.dart';

/// A minimal serializable version of MediaKit's [Media].
class SerializedMedia {
  final String uri;
  final String title;
  final double volume;

  const SerializedMedia({
    required this.uri,
    required this.title,
    this.volume = 100.0,
  });

  /// Creates a [SerializedMedia] from a [Media].
  static SerializedMedia fromMedia(Media media) => SerializedMedia(
    uri: media.uri,
    title: media.extras?['title'] ?? 'Missing title',
    volume: media.extras?['volume'] ?? 100.0,
  );

  /// Converts the [SerializedMedia] to a [Media].
  Media toMedia() => Media(
    uri,
    extras: MediaBuilder.createExtras(title: title, volume: volume),
  );
}

/// Provides storage for a playlist.
/// No persistent storage on Web.
abstract class PlaylistStorageService {
  /// Intializes a [PlaylistStorageService] implementation.
  /// If [paths] is not empty, it is used to replace the contents of the playlist.
  static Future<PlaylistStorageService> init({
    required Player player,
    required List<String> paths,
  }) async {
    if (kIsWeb) {
      return PlaylistStorageServiceNoop();
    } else {
      return PlaylistStorageServiceHive.init(player, paths);
    }
  }

  /// Returns the persisted playlist.
  Future<List<Media>> getAll();

  /// Replaces any persisted playlist with the provided playlist.
  Future<void> putAll(List<Media> medias);

  /// Updates the [Media] at the provided index.
  Future<void> put(int index, Media media);
}

/// Provides persistent storage for a playlist using Hive CE.
class PlaylistStorageServiceHive implements PlaylistStorageService {
  final Box<SerializedMedia> _box;

  PlaylistStorageServiceHive._(Box<SerializedMedia> box) : _box = box;

  /// Initializes the [PlaylistStorageServiceHive].
  /// - Sets up a Hive box.
  /// - Loads the saved playlist into [Player].
  /// - Listens to [Player] playlist changes and saves them.
  static Future<PlaylistStorageServiceHive> init(
    Player player,
    List<String> paths,
  ) async {
    final boxName = '${Constants.namespace}.playlist';
    final directory = await Constants.getDataDir();
    final box = directory == null
        ? await Hive.openBox<SerializedMedia>(boxName)
        : await Hive.openBox<SerializedMedia>(boxName, path: directory.path);
    final playlistStorage = PlaylistStorageServiceHive._(box);
    player.stream.playlist.listen(
      (playlist) async => await playlistStorage.putAll(playlist.medias),
    );
    final medias = await (paths.isEmpty
        ? playlistStorage.getAll()
        : Future.wait(
            paths.map(
              (filePath) async => await MediaBuilder.fromPathString(
                filePath: filePath,
                volume: player.state.volume,
              ),
            ),
          ));
    await player.open(Playlist(medias), play: false);

    return playlistStorage;
  }

  /// Returns the persisted playlist.
  @override
  Future<List<Media>> getAll() async {
    return _box.values
        .map((serializedMedia) => serializedMedia.toMedia())
        .toList();
  }

  /// Replaces any persisted playlist with the provided playlist.
  @override
  Future<void> putAll(List<Media> medias) async {
    await _box.clear();
    _box.addAll(medias.map(SerializedMedia.fromMedia));
  }

  /// Updates the [Media] at the provided index.
  @override
  Future<void> put(int index, Media media) async {
    return _box.putAt(index, SerializedMedia.fromMedia(media));
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
  Future<void> putAll(List<Media> medias) => Future.value(null);

  /// Updates the [Media] at the provided index.
  @override
  Future<void> put(int index, Media media) => Future.value(null);
}
