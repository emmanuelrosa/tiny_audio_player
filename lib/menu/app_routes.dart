import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:tiny_audio_player/about/about_view.dart';
import 'package:tiny_audio_player/home/home_view.dart';
import 'package:tiny_audio_player/share/share_view.dart';

/// Provides all of the application's navigation routes.
class AppRoutes {
  static String get home => '/';

  static String get share => '/share';

  static String get about => '/about';

  static Map<String, Widget Function(BuildContext)> get routes => {
    home: (context) => LoaderOverlay(child: HomeView()),
    share: (context) => ShareView(),
    about: (context) => AboutView(),
  };
}
