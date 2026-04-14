{
  inputs,
  pkgs,
  ...
}: let
  treefmt = inputs.treefmt.lib.evalModule pkgs (_: {
    projectRootFile = "flake.nix";
    programs.alejandra.enable = true;
  });
in
  treefmt.config.build.wrapper
