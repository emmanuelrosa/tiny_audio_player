import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:media_kit/media_kit.dart';
import 'package:provider/provider.dart';
import 'package:tiny_audio_player/home/home_view.dart';
import 'package:tiny_audio_player/menu/app_routes.dart';
import 'package:tiny_audio_player/playcontrol/animated_playcontrol_widget.dart';
import 'package:tiny_audio_player/playlist/file_picker_service.dart';
import 'package:tiny_audio_player/playlist/playlist_list_view.dart';
import 'package:tiny_audio_player/share/share_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  final player = Player();
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
      ],
      child: MaterialApp(
        title: 'Tiny Audio Player',
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: .dark,
        routes: AppRoutes.routes,
      ),
    );
  }
}
