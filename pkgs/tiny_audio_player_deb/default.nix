{ stdenvNoCC
, lib
, system
, tiny_audio_player
, appVersion
, patchelf
, dpkg
}: let
  arch = {
    "x86_64-linux" = "amd64";
    "aarch64-linux" = "aarch64";
  }."${system}";

  ldArch = {
    "x86_64-linux" = "linux-x86-64";
    "aarch64-linux" = "linux-aarch64";
  }."${system}";

  controlFile = builtins.toFile "control" ''
    Package: tiny-audio-player
    Version: ${appVersion}
    Maintainer: Emmanuel Rosa <emmanuelrosa@protonmail.com>
    Depends: xdg-user-dirs, libgtk-3-0t64, libfontconfig1, libgles2, libmpv2, libepoxy0, libbz2-1.0, libbrotli1, libexpat1
    Architecture: ${arch}
    Homepage: https://github.com/emmanuelrosa/tiny_audio_player/
    Description: ${tiny_audio_player.meta.description}
  '';

  appdir = stdenvNoCC.mkDerivation {
    name = "tiny-audio-player_${appVersion}-1_${arch}";
    src = tiny_audio_player;
    nativeBuildInputs = [ patchelf ];
    dontStrip = true;
    dontAutoPatchelf = true;
    dontFixup = true;
  
    buildPhase = ''
      lib_base_dir=/lib/${system}-gnu
      app_lib_dir=/usr/share/tiny_audio_player/lib
  
      pushd app/tiny_audio_player
      patchelf --set-interpreter "/lib64/ld-${ldArch}.so.2" tiny_audio_player
      patchelf --set-rpath $lib_base_dir/:$app_lib_dir/ tiny_audio_player
  
      patchelf --set-rpath $lib_base_dir/ ./lib/libflutter_linux_gtk.so
      patchelf --set-rpath $lib_base_dir/:$app_lib_dir/ ./lib/libmedia_kit_libs_linux_plugin.so
      patchelf --set-rpath $lib_base_dir/:$app_lib_dir/ ./lib/liburl_launcher_linux_plugin.so
      popd
    '';
  
    installPhase = ''
      mkdir -p $out/usr/bin
      mkdir -p $out/usr/share/tiny_audio_player/lib
      mkdir -p $out/usr/share/tiny_audio_player/data
      mkdir -p $out/DEBIAN
  
      cp app/tiny_audio_player/tiny_audio_player $out/usr/share/tiny_audio_player/tiny_audio_player
      ln -s /usr/share/tiny_audio_player/tiny_audio_player $out/usr/bin/tiny_audio_player
      cp -r app/tiny_audio_player/data/. $out/usr/share/tiny_audio_player/data/
      cp -r app/tiny_audio_player/lib/. $out/usr/share/tiny_audio_player/lib/
      cp -r share/. $out/usr/share/
      cp ${controlFile} $out/DEBIAN/control
    '';
  };
in stdenvNoCC.mkDerivation rec {
  name = "tiny-audio-player_${appVersion}-1_${arch}.deb";
  src = appdir;
  nativeBuildInputs = [ dpkg ];

  buildPhase = ''
    dpkg-deb --build ./ package.deb
  '';

  installPhase = ''
    mkdir $out
    cp package.deb $out/${name}
  '';

  meta = {
    homepage = "https://github.com/emmanuelrosa/tiny_audio_player";
    description = "A minimalist audio player, written in Dart/Flutter";
    longDescription = "This is an Ubuntu/Debian package built from the Nix package.";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ emmanuelrosa ];
  };
}
