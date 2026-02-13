{ flutter
, appVersion
, runCommand
, lib
, gnutar
}: let
  app = flutter.buildFlutterApplication rec {
    pname = "tiny_audio_player_web";
    version = appVersion;
    src = ./../..;
    pubspecLock = lib.importJSON "${src}/pubspec.lock.json";
    targetFlutterPlatform = "web";
    flutterBuildFlags = [ "--wasm" "--base-href" "/tiny_audio_player/" "--dart-define=BASE_HREF=/tiny_audio_player/" ];

    meta = {
      homepage = "https://github.com/emmanuelrosa/tiny_audio_player";
      description = "A web-based minimalist audio player, written in Dart/Flutter";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [ emmanuelrosa ];
    };
  };
in runCommand "tiny_audio_player_web.tar.gz" { } ''
  ${gnutar}/bin/tar -C ${app} -czf $out .
''
