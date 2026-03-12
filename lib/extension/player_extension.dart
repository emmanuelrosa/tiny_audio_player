import 'package:media_kit/media_kit.dart';

/// Extensions for [Player].
extension PlayerUtils on Player {
  /// Neither [player.play()] nor [player.playOrPause()] work consistently.
  /// I think it's because I'm using a playlist, which seems to require
  /// a [player.jump()] to start the initial playback.
  /// This method takes care of that.
  Future<void> playOrPauseFixed() {
    final index = state.playlist.index;
    final position = state.position;
    return state.playing ? pause() : jump(index).then((_) => seek(position));
  }
}
