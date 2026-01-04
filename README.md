# Tiny Audio Player

A minimalist audio player, written in Dart/Flutter.

![Screenshot](screenshot.jpeg)

## Features

- A single (ephemeral) playlist to queue your audio files.
- Play/pause, prior/next track, and volume controls.
- No user data collection.

That's it! I did say this is a *minimalist* audio player.

## Getting Started

Try it online at [https://emmanuelrosa.github.io/tiny_audio_player/](https://emmanuelrosa.github.io/tiny_audio_player/).

- To add audio files, click on the "+" button on the lower-right of the screen.
- To re-order your playlist, drag-n-drop. On narrow screens you'll need to long-press first.
- To remove a track from your playlist, click on the red trash/rubbish bin. If you don't see one, swipe and then click on the red button.
- The progress bar also functions as a slider. Use it to seek to a position within the audio track.
- Clicking on the speaker button next to the progress bar toggles the volume control.

## Credits

This app would not have been possible without the wonderful [Flutter](https://flutter.dev/) community. Check out these awesome Dart and/or Flutter packages:

- [media_kit](https://pub.dev/packages/media_kit) - Handles the audio playback wonderfully.
- [provider](https://pub.dev/packages/provider) - Simplifies dependency injection.
- [flutter_slidable](https://pub.dev/packages/flutter_slidable) - Wrap you widget so you can flick it and delete it.
- [waveform_flutter](https://pub.dev/packages/waveform_flutter) - I use this to generate a random waveform during playback.
- [heroicons](https://pub.dev/packages/heroicons) - A really nice collection of icons. This will probably become my go-to for icons.
- [path](https://pub.dev/packages/path) - Really nice package for parsing file system and URI paths.
- [file_picker](https://pub.dev/packages/file_picker) - My go-to package when I want to prompt users to select a file.
- [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons) - A big time saver when creating app icons.
- [flutter_native_splash](https://pub.dev/packages/flutter_native_splash) - This package takes care of showing a splash screen. Very useful for Flutter web.

## Build notes

- Building as WASM breaks the PWA install button, but it doesn't seem to break actual PWA installs.
