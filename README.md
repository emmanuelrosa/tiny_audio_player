# Tiny Audio Player

A minimalist audio player, written in Dart/Flutter.

![Screenshot](screenshot.jpeg)

## Features

- Easy to use - Just add audio tracks to the playlist and tap/click to play.
- No user data collection.
- Can be installed as a PWA (progressive web application).

The main concept within *Tiny Audio Player* is the playlist. You simply add the audio tracks you want to listen to, sort them as you wish, and press _PLAY_.

## Bonus features

### Per-track volume

You know how sometimes there's an audio track that is just too loud compared to the others? With *Tiny Audio Player*, you can simply adjust the volume and it will automatically apply your adjustments as it goes through each track on your playlist.

## Getting Started

Try it online at [https://emmanuelrosa.github.io/tiny_audio_player/](https://emmanuelrosa.github.io/tiny_audio_player/).

- To add audio files, click on the "+" button on the lower-right of the screen.
- To re-order your playlist, drag-n-drop. On narrow screens you'll need to long-press first.
- To remove a track from your playlist, click on the red trash/rubbish bin. If you don't see one, swipe and then click on the red button.
- To play/pause, simply tap on the appropriate audio track.
- Expand the playback controls (on the bottom of the screen) for additional options.

## User data

Tiny Audio Player uses a database to store settings, and on native builds, your playlist. This data remains on your computer at all times. It is never shared with anyone.

## Credits

This app would not have been possible without the wonderful [Flutter](https://flutter.dev/) community. Check out these awesome Dart and/or Flutter packages:

- [media_kit](https://pub.dev/packages/media_kit) - Handles the audio playback wonderfully.
- [provider](https://pub.dev/packages/provider) - Simplifies dependency injection.
- [flutter_slidable](https://pub.dev/packages/flutter_slidable) - Wrap you widget so you can flick it and delete it.
- [path](https://pub.dev/packages/path) - Really nice package for parsing file system and URI paths.
- [file_picker](https://pub.dev/packages/file_picker) - My go-to package when I want to prompt users to select a file.
- [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons) - A big time saver when creating app icons.
- [flutter_native_splash](https://pub.dev/packages/flutter_native_splash) - This package takes care of showing a splash screen. Very useful for Flutter web.
- [loader_overlay](https://pub.dev/packages/loader_overlay) - An easy way to show a loading indicator overlay during a long-running task.
- [hive_ce](https://pub.dev/packages/hive_ce) - A very nice key/value store, used to persist the player state (mostly on Desktop, not Web).
