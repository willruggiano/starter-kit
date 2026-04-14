{
  inputs,
  pkgs,
  ...
}: let
  inherit (pkgs) lib;

  treefmt = inputs.treefmt.lib.evalModule pkgs (_: {
    projectRootFile = "flake.nix";
    programs = {
      # Json and Markdown
      prettier.enable = true;
      # Nix
      alejandra.enable = true;
      # Python
      ruff-format.enable = true;
      # Shell
      shfmt.enable = true;
    };
    settings.formatter = {
      prettier = {
        includes = lib.mkForce ["*.json" "*.md"];
        proseWrap = "always";
      };
    };
  });
in
  treefmt.config.build.wrapper
