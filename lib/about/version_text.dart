import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

/// Obtains the app version asynchronously and renders it.
class VersionText extends StatelessWidget {
  const VersionText({super.key});

  @override
  Widget build(BuildContext context) => Provider<Future<PackageInfo>>(
    create: (_) => PackageInfo.fromPlatform(),
    builder: (context, _) => FutureBuilder(
      future: context.read<Future<PackageInfo>>(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final packageInfo = snapshot.data!;

          return Text('version: ${packageInfo.version}');
        } else if (snapshot.hasError) {
          return const Text('version: unknown');
        } else {
          return CircularProgressIndicator();
        }
      },
    ),
  );
}
