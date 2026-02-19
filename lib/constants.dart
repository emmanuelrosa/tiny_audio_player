import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

/// Application-wide constants.
class Constants {
  static String get appName => 'tiny_audio_player';

  static String get namespace => 'com.github.emmanuelrosa.tiny_audio_player';

  static Future<Directory?> getDataDir() async {
    if (kIsWeb) {
      return Future.value(null);
    }

    try {
      final docsDir = await getApplicationDocumentsDirectory();
      return Future.value(Directory(path.join(docsDir.path, appName)));
    } on MissingPlatformDirectoryException {
      final homeDir = await getHomeDirectory();
      return Future.value(
        homeDir == null ? null : Directory(path.join(homeDir.path, appName)),
      );
    }
  }

  static Future<Directory?> getHomeDirectory() async {
    return Future.value(switch (Platform.operatingSystem) {
      'linux' => Directory(Platform.environment['HOME']!),
      'macos' => Directory(Platform.environment['HOME']!),
      'windows' => Directory(Platform.environment['USERPROFILE']!),
      _ => null,
    });
  }
}
