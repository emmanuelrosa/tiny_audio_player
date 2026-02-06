import 'package:hive_ce/hive_ce.dart';
import 'package:media_kit/media_kit.dart';
import 'package:tiny_audio_player/constants.dart';

/// Provides access and persistance for application settings.
class SettingsService {
  final Box _box;

  SettingsService._(Box box) : _box = box;

  /// Initializes the [SettingsService].
  /// - Sets up a Hive box.
  /// - Applies the saved settings to [Player].
  /// - Listens to [Player] changes and saves them.
  static Future<SettingsService> init(Player player) async {
    final directory = await Constants.getDataDir();
    final box = directory == null
        ? await Hive.openBox('${Constants.namespace}.settings')
        : await Hive.openBox(
            '${Constants.namespace}.settings',
            path: directory.path,
          );
    final settings = SettingsService._(box);
    await player.setVolume(await settings.getVolume());
    player.stream.volume.listen((volume) => settings.setVolume(volume));

    return Future.value(settings);
  }

  /// Returns the playback volume setting.
  Future<double> getVolume() {
    final defaultValue = 100.0;
    return Future.value(
      _box.get('volume', defaultValue: defaultValue) as double,
    );
  }

  /// Sets the playback volume setting.
  Future<void> setVolume(double value) {
    return _box.put('volume', value);
  }
}
