import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

final _url = Uri.parse('https://github.com/emmanuelrosa/tiny_audio_player/');

/// Renders a widget to either open the user's web browser to the project's page
/// or a button to copy the project's URL to the clipboard.
/// The clipboard method is used for Web because it's more reliable.
class ProjectLink extends StatelessWidget {
  const ProjectLink({super.key});

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return _ProjectLinkClipboard();
    } else {
      return _ProjectLinkButton();
    }
  }
}

class _ProjectLinkButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextButton(
      onPressed: () => _openInBrowser(_url),
      child: Text(
        _url.toString(),
        overflow: .ellipsis,
        style: theme.textTheme.bodySmall?.copyWith(
          color: Colors.lightBlue,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  Future<void> _openInBrowser(Uri url) => launchUrl(url);
}

class _ProjectLinkClipboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: .center,
      children: [
        Text(_url.toString(), style: theme.textTheme.bodySmall),
        IconButton(
          onPressed: () => _copyToClipboard(context, _url.toString()),
          tooltip: 'Copy link to clipboard',
          icon: Icon(Icons.copy),
        ),
      ],
    );
  }

  Future<void> _copyToClipboard(BuildContext context, String text) async {
    final messenger = ScaffoldMessenger.of(context);

    await Clipboard.setData(ClipboardData(text: text));
    messenger.showSnackBar(SnackBar(content: const Text('Copied!')));
  }
}
