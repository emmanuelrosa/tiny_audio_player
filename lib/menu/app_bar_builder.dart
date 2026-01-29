import 'package:flutter/material.dart';
import 'package:tiny_audio_player/menu/app_routes.dart';

enum AppBarType { normal, minimal }

/// Creates the [AppBar] that's used through this application.
class AppBarBuilder {
  static PreferredSizeWidget build(
    BuildContext context, {
    AppBarType type = AppBarType.normal,
  }) {
    final theme = Theme.of(context);
    final navigator = Navigator.of(context);

    return AppBar(
      title: const Text('Tiny Audio Player'),
      backgroundColor: theme.colorScheme.inversePrimary,
      actions: [
        if (type == .normal)
          IconButton(
            onPressed: () => navigator.pushNamed(AppRoutes.share),
            tooltip: 'Share this app.',
            icon: Icon(Icons.share),
          ),
      ],
    );
  }
}
