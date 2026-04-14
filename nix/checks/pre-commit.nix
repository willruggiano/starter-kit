{
  inputs,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) system;
in
  inputs.git-hooks.lib.${system}.run {
    src = inputs.self;
    hooks = {
      deadnix.enable = true;
      nil.enable = true;
      statix.enable = true;
      treefmt = {
        enable = true;
        package = inputs.self.packages.${system}.formatter;
      };
    };
  }
