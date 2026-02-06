import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:media_kit/media_kit.dart';
import 'package:provider/provider.dart';
import 'package:tiny_audio_player/hive/hive_registrar.g.dart';
import 'package:tiny_audio_player/menu/app_routes.dart';
import 'package:tiny_audio_player/playlist/file_picker_service.dart';
import 'package:tiny_audio_player/playlist/playlist_storage_adapter.dart';
import 'package:tiny_audio_player/playlist/playlist_storage_service.dart';
import 'package:tiny_audio_player/settings/settings_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  Hive.registerAdapters();
  final player = Player();
  await SettingsService.init(player);
  runApp(MyApp(player: player));
}

class MyApp extends StatelessWidget {
  final Player player;

  const MyApp({super.key, required this.player});

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
        Provider<FilePickerService>(create: (_) => FilePickerService(player)),
        Provider<PlaylistStorageService>(
          create: (_) => PlaylistStorageService.init(),
        ),
      ],
      builder: (context, _) {
        final player = context.read<Player>();
        final playlistStorageService = context.read<PlaylistStorageService>();

        return MultiProvider(
          providers: [
            Provider.value(
              value: PlaylistStorageAdapter(
                player: player,
                storageService: playlistStorageService,
              ),
            ),
          ],
          builder: (context, _) => MaterialApp(
            title: 'Tiny Audio Player',
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: .dark,
            routes: AppRoutes.routes,
          ),
        );
      },
    );
  }
}
