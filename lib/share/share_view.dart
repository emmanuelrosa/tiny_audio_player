import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tiny_audio_player/menu/app_bar_builder.dart';

const _url = 'https://emmanuelrosa.github.io/tiny_audio_player/';

/// A page which shows a QR code with the URL to this app.
class ShareView extends StatelessWidget {
  const ShareView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBarBuilder.build(context, type: .minimal),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                const imageSize = 111.0;
                final maxSize = math.min(
                  constraints.maxWidth,
                  constraints.maxHeight,
                );
                final size = math.min(400.0, constraints.maxWidth);
                final scale = imageSize / size;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Image.asset('assets/qrcode.png', scale: scale),
                );
              },
            ),
            Row(
              mainAxisAlignment: .center,
              children: [
                Text(_url, style: theme.textTheme.bodySmall),
                IconButton(
                  onPressed: () => _copyToClipboard(context, _url),
                  tooltip: 'Copy link to clipboard',
                  icon: Icon(Icons.copy),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _copyToClipboard(BuildContext context, String text) async {
    final messenger = ScaffoldMessenger.of(context);

    await Clipboard.setData(ClipboardData(text: text));
    messenger.showSnackBar(SnackBar(content: const Text('Copied!')));
  }
}
