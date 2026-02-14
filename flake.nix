{
  description = "A Nix flake for Tiny Audio Player";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/master";
  };

  outputs = { self, nixpkgs }: let
    forAllSystems = func: nixpkgs.lib.genAttrs [
      "x86_64-linux"
      "aarch64-linux"
    ] (system:
      func (
        import nixpkgs {
          inherit system;
        }
      )
      system
    );
  in {
    lib = forAllSystems (pkgs: system: {
      fromYAML = path: builtins.fromJSON(builtins.readFile(pkgs.runCommand "yaml-to-json" {
        nativeBuildInputs = [ pkgs.yq ];
      } ''
        yq < ${path} > $out
      ''));

      appVersion = (self.lib."${system}".fromYAML ./pubspec.yaml).version;
    });

    packages = forAllSystems (pkgs: system: {
      dart-flutter = pkgs.callPackage ./pkgs/dart-flutter {};

      vim = pkgs.callPackage ./pkgs/vim {
        dart = self.packages."${system}".dart-flutter;
      };

      tiny_audio_player = pkgs.callPackage ./pkgs/tiny_audio_player {
        inherit (self.lib."${system}") appVersion;
      };

      tiny_audio_player_web = pkgs.callPackage ./pkgs/tiny_audio_player_web {
        inherit (self.lib."${system}") appVersion;
      };

      tiny_audio_player_deb = pkgs.callPackage ./pkgs/tiny_audio_player_deb {
        inherit system;
        inherit (self.lib."${system}") appVersion;
        tiny_audio_player = self.packages."${system}".tiny_audio_player;
      };

      default = self.packages."${system}".tiny_audio_player;
    });
  };
}
