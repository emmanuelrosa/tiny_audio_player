import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiny_audio_player/menu/app_bar_builder.dart';
import 'package:tiny_audio_player/playcontrol/animated_playcontrol_widget.dart';
import 'package:tiny_audio_player/playlist/file_picker_service.dart';
import 'package:tiny_audio_player/playlist/playlist_list_view.dart';

/// The home page.
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final filePicker = Provider.of<FilePickerService>(context);

    return Scaffold(
      appBar: AppBarBuilder.build(context),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [Expanded(child: PlaylistListView())],
        ),
      ),
      bottomNavigationBar: AnimatedPlaycontrolWidget(
        duration: Duration(seconds: 1),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => filePicker.pickFiles(context),
        tooltip: 'Add audio files',
        child: const Icon(Icons.playlist_add_rounded),
      ),
    );
  }
}
