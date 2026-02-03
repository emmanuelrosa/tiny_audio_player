import 'package:media_kit/media_kit.dart';
import 'package:tiny_audio_player/playlist/playlist_storage_service.dart';

/// Synchronizes the [Player]'s playlist with the [PlaylistStorageService].
/// A listener is set up to save the playlist to storage when it changes.
/// Loading the playlist needs to be handled elsewhere.
class PlaylistStorageAdapter {
  final Player player;
  final PlaylistStorageService storageService;

  PlaylistStorageAdapter({required this.player, required this.storageService}) {
    player.stream.playlist.listen(
      (newPlaylist) => storageService.putAll(newPlaylist.medias),
    );
  }
}
