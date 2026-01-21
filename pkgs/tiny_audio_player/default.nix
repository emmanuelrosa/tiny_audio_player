{ flutter
, lib
, xdg-user-dirs
, mpv-unwrapped
, makeDesktopItem
, copyDesktopItems
, imagemagick
}: flutter.buildFlutterApplication rec {
  pname = "tiny_audio_player";
  version = "1.0.0";
  src = ./../..;
  nativeBuildInputs = [ copyDesktopItems imagemagick ];
  pubspecLock = lib.importJSON "${src}/pubspec.lock.json";
  extraWrapProgramArgs = "--set LD_LIBRARY_PATH ${mpv-unwrapped}/lib --set PATH ${lib.makeBinPath [ xdg-user-dirs ]}";

  postInstall = ''
    for n in 16 24 32 48 64 96 128 256; do
      size=$n"x"$n
      mkdir -p $out/share/icons/hicolor/$size/apps
      convert assets/icon/icon.png -resize $size $out/share/icons/hicolor/$size/apps/tiny_audio_player.png
    done;
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "tiny_audio_player";
      exec = "tiny_audio_player";
      icon = "tiny_audio_player";
      desktopName = "Tiny Audio Player";
      genericName = "Audio Player";
      categories = [ "Audio" "Player"];
      mimeTypes = [
        "audio/mp3"
        "audio/m4a"
        "audio/aac"
        "audio/flac"
        "audio/ogg"
        "audio/oga"
        "audio/x-opus+ogg"
        "audio/wma"
        "audio/wav"
        "audio/x-aiff"
        "audio/x-aifc"
        "audio/ac3"
        "audio/dts"
        "audio/x-ape"
        "audio/x-matroska"
        "audio/vnd.avi"
        "audio/vnd.wav"
        "audio/mp4"
        "audio/quicktime"
      ];
    })
  ];

  meta = {
    homepage = "https://github.com/emmanuelrosa/tiny_audio_player";
    description = "A minimalist audio player, written in Dart/Flutter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ emmanuelrosa ];
  };
}
