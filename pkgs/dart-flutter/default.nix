{ lib
, symlinkJoin
, flutter
}: symlinkJoin {
  name = "dart-flutter-${flutter.version}";
  paths = [ "${flutter}/bin/cache/dart-sdk" ];

  meta = {
    homepage = "https://dart.dev";
    description = "Scalable programming language, with robust libraries and runtimes, for building web, server, and mobile apps";
    longDescription = "This package takes the Dart SDK that's bundled with the Flutter SDK, and exposes it so it can be used as a normal Dart SDK package";

    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];

    mainProgram = "dart";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ emmanuelrosa ];
  };
}

