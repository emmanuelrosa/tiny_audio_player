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
    packages = forAllSystems (pkgs: system: {
      dart-flutter = pkgs.callPackage ./pkgs/dart-flutter {};

      vim = pkgs.callPackage ./pkgs/vim {
        dart = self.packages."${system}".dart-flutter;
      };

      tiny_audio_player = pkgs.callPackage ./pkgs/tiny_audio_player {};

      tiny_audio_player_web = pkgs.callPackage ./pkgs/tiny_audio_player_web {};

      default = self.packages."${system}".tiny_audio_player;
    });
  };
}
