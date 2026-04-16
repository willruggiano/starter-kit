{inputs, ...}: {
  perSystem = {pkgs, ...}: {
    checks = {
      governance =
        pkgs.runCommand "check-governance" {
          src = inputs.self;
          nativeBuildInputs = [pkgs.bash];
        } ''
          bash ${./check-governance.sh} "$src"
          touch "$out"
        '';
      state = let
        python = pkgs.python3.withPackages (ps: [ps.jsonschema]);
      in
        pkgs.runCommand "check-state" {
          src = inputs.self;
          nativeBuildInputs = [python];
        } ''
          python ${./check-state.py} "$src"
          touch "$out"
        '';
    };
  };
}
