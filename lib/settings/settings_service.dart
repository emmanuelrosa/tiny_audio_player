import 'package:hive_ce/hive_ce.dart';
import 'package:media_kit/media_kit.dart';
import 'package:tiny_audio_player/constants.dart';

class _SettingsServiceKeys {
  static String volume = 'volume';
  static String playlistMode = 'playlistMode';
}

/// Provides access and persistance for application settings.
class SettingsService {
  final Box _box;

  SettingsService._(Box box) : _box = box;

  /// Initializes the [SettingsService].
  /// - Sets up a Hive box.
  /// - Applies the saved settings to [Player].
  /// - Listens to [Player] changes and saves them.
  static Future<SettingsService> init(Player player) async {
    final boxName = '${Constants.namespace}.settings';
    final directory = await Constants.getDataDir();
    final box = directory == null
        ? await Hive.openBox(boxName)
        : await Hive.openBox(boxName, path: directory.path);
    final settings = SettingsService._(box);
    await player.setVolume(await settings.getVolume());
    await player.setPlaylistMode(await settings.getPlaylistMode());
    player.stream.volume.listen(
      (volume) async => await settings.setVolume(volume),
    );
    player.stream.playlistMode.listen(
      (mode) async => await settings.setPlaylistMode(mode),
    );

    return Future.value(settings);
  }

  /// Returns the playback volume setting.
  Future<double> getVolume() {
    final defaultValue = 100.0;
    return Future.value(
      _box.get(_SettingsServiceKeys.volume, defaultValue: defaultValue)
          as double,
    );
  }

  /// Returns the playlist mode.
  Future<PlaylistMode> getPlaylistMode() {
    final defaultValue = PlaylistMode.none;
    return Future.value(
      _box.get(_SettingsServiceKeys.playlistMode, defaultValue: defaultValue)
          as PlaylistMode,
    );
  }

  /// Sets the playback volume setting.
  Future<void> setVolume(double value) {
    return _box.put(_SettingsServiceKeys.volume, value);
  }

  /// Sets the playlist mode.
  Future<void> setPlaylistMode(PlaylistMode value) {
    return _box.put(_SettingsServiceKeys.playlistMode, value);
  }
}
