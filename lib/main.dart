import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:media_kit/media_kit.dart';
import 'package:provider/provider.dart';
import 'package:tiny_audio_player/hive/hive_registrar.g.dart';
import 'package:tiny_audio_player/menu/app_routes.dart';
import 'package:tiny_audio_player/playlist/file_picker_service.dart';
import 'package:tiny_audio_player/playlist/playlist_storage_service.dart';
import 'package:tiny_audio_player/settings/settings_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  Hive.registerAdapters();
  final player = Player();
  await SettingsService.init(player);
  final playlistStorageService = await PlaylistStorageService.init(player);
  runApp(MyApp(player: player, playlistStorageService: playlistStorageService));
}

class MyApp extends StatelessWidget {
  final Player player;
  final PlaylistStorageService playlistStorageService;

  const MyApp({
    super.key,
    required this.player,
    required this.playlistStorageService,
  });

  @override
  Widget build(BuildContext context) {
    final seedColor = Color(0x006D8196);
    final cardTheme = CardThemeData(shape: LinearBorder());
    final lightTheme = ThemeData(
      colorScheme: .fromSeed(seedColor: seedColor, brightness: .light),
      cardTheme: cardTheme,
      brightness: .light,
    );
    final darkTheme = ThemeData(
      colorScheme: .fromSeed(seedColor: seedColor, brightness: .dark),
      cardTheme: cardTheme,
      brightness: .dark,
    );

    return MultiProvider(
      providers: [
        Provider<Player>.value(value: player),
        Provider<PlaylistStorageService>.value(value: playlistStorageService),
        Provider<FilePickerService>(create: (_) => FilePickerService(player)),
      ],
      builder: (context, _) => MaterialApp(
        title: 'Tiny Audio Player',
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: .dark,
        routes: AppRoutes.routes,
      ),
    );
  }
}
