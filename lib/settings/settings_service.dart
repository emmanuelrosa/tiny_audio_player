import 'package:hive_ce/hive_ce.dart';
import 'package:tiny_audio_player/constants.dart';

/// Provides access and persistance for application settings.
class SettingsService {
  late Future<Box> _futureBox;

  SettingsService() {
    _futureBox = Constants.getDataDir().then((directory) {
      if (directory == null) {
        return Hive.openBox('${Constants.namespace}.settings');
      } else {
        return Hive.openBox(
          '${Constants.namespace}.settings',
          path: directory.path,
        );
      }
    });
  }

  /// Returns the playback volume setting.
  Future<double> getVolume() async {
    final defaultValue = 100.0;
    final box = await _futureBox;
    return box.get('volume', defaultValue: defaultValue) as double;
  }

  /// Sets the playback volume setting.
  void setVolume(double value) {
    _futureBox.then((box) => box.put('volume', value));
  }
}
