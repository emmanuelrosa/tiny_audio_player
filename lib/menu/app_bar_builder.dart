import 'package:flutter/material.dart';
import 'package:tiny_audio_player/menu/app_routes.dart';

enum AppBarType { normal, minimal }

/// Creates the [AppBar] that's used through this application.
class AppBarBuilder {
  static PreferredSizeWidget build(
    BuildContext context, {
    required String title,
    AppBarType type = AppBarType.normal,
  }) {
    final theme = Theme.of(context);
    final navigator = Navigator.of(context);

    return AppBar(
      title: Text(title),
      backgroundColor: theme.colorScheme.inversePrimary,
      actions: [
        if (type == .normal)
          IconButton(
            onPressed: () => navigator.pushNamed(AppRoutes.share),
            tooltip: 'Share this app.',
            icon: Icon(Icons.share_rounded),
          ),
        if (type == .normal)
          IconButton(
            onPressed: () => navigator.pushNamed(AppRoutes.about),
            tooltip: 'Learn about this app.',
            icon: Icon(Icons.info_outline_rounded),
          ),
      ],
    );
  }
}
