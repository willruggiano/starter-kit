{
  inputs,
  pkgs,
  ...
}: let
  python = pkgs.python3.withPackages (ps: [ps.jsonschema]);
in
  pkgs.runCommand "check-state" {
    src = inputs.self;
    nativeBuildInputs = [python];
  } ''
    python ${./state.py} "$src"
    touch "$out"
  ''
