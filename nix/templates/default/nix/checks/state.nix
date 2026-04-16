{
  pkgs,
  self,
}: let
  python = pkgs.python3.withPackages (ps: [ps.jsonschema]);
in
  pkgs.runCommand "check-state" {
    src = self;
    nativeBuildInputs = [python];
  } ''
    python ${./state.py} "$src"
    touch "$out"
  ''
