import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:provider/provider.dart';
import 'package:tiny_audio_player/playcontrol/playcontrol_widget.dart';
import 'package:tiny_audio_player/playlist/file_picker_service.dart';
import 'package:tiny_audio_player/playlist/playlist_list_view.dart';

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
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final filePicker = Provider.of<FilePickerService>(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [Expanded(child: PlaylistListView())],
        ),
      ),
      bottomNavigationBar: Consumer<Player>(
        builder: (context, player, _) => StreamProvider<Playlist>.value(
          initialData: player.state.playlist,
          value: player.stream.playlist,
          updateShouldNotify: (a, b) => a.medias.length != b.medias.length,
          builder: (context, _) => Consumer<Playlist>(
            builder: (context, playlist, _) => playlist.medias.isNotEmpty
                ? PlaycontrolWidget(player: player)
                : SizedBox(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => filePicker.pickFiles(),
        tooltip: 'Add audio files',
        child: const Icon(Icons.add),
      ),
    );
  }
}
