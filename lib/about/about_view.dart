import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:tiny_audio_player/about/version_text.dart';
import 'package:tiny_audio_player/menu/app_bar_builder.dart';
import 'package:url_launcher/url_launcher.dart';

final _url = Uri.parse('https://github.com/emmanuelrosa/tiny_audio_player/');

/// A page which shows some information about this app.
class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBarBuilder.build(context, title: 'About', type: .minimal),
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = math.min(450.0, constraints.maxWidth);
            final minWidth = 350.0;

            return SizedBox(
              width: width,
              child: Column(
                spacing: 10.0,
                mainAxisAlignment: .center,
                children: [
                  Text(
                    'Tiny Audio Player',
                    style: theme.textTheme.headlineLarge,
                  ),
                  const VersionText(),
                  Text(
                    'Tiny Audio Player is an open-source minimalist audio player created by Emmanuel Rosa.',
                  ),
                  Text(
                    'Designed to be easy to use and with data privacy in mind, with Tiny Audio Player you can quicky get started listening to your audio tracks without leaking your data to our corporate overlords.',
                  ),
                  if (constraints.maxWidth > minWidth)
                    Text(
                      'To learn more about the project, visit the link below.',
                    ),
                  if (constraints.maxWidth > minWidth)
                    Row(
                      mainAxisAlignment: .center,
                      children: [
                        TextButton(
                          onPressed: () => _openInBrowser(_url),
                          child: Text(
                            _url.toString(),
                            overflow: .ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.lightBlue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _openInBrowser(Uri url) => launchUrl(url);
}
