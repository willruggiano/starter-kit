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
      # Formatting
      treefmt = {
        enable = true;
        package = inputs.self.packages.${system}.formatter;
      };
      # GitHub Actions
      actionlint.enable = true;
      # Nix
      deadnix.enable = true;
      nil.enable = true;
      statix.enable = true;
      # Python
      ruff.enable = true;
      # Shell
      shellcheck.enable = true;
    };
  }
