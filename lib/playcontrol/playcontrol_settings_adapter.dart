import 'package:media_kit/media_kit.dart';
import 'package:tiny_audio_player/settings/settings_service.dart';

/// Synchronizes the play control settings between the [Player] and the [SettingsService].
/// First, it attempts to load the volume setting from the [SettingsService],
/// and apply it to the [Player].
/// Then, it sets up a stream listener so that when the [Player] volume changes
/// the volume is saved view the [SettingsService].
class PlaycontrolSettingsAdapter {
  final Player player;
  final SettingsService settings;

  PlaycontrolSettingsAdapter({required this.player, required this.settings}) {
    settings.getVolume().then((volume) async {
      await player.setVolume(volume);
      player.stream.volume.listen((newVolume) => settings.setVolume(newVolume));
    });
  }
}
