{inputs, ...}: {
  perSystem = {
    config,
    pkgs,
    system,
    ...
  }: {
    checks.pre-commit = inputs.git-hooks.lib.${system}.run {
      src = inputs.self;
      hooks = {
        # Formatting
        treefmt = {
          enable = true;
          package = config.packages.treefmt;
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
        # Governance
        governance = {
          enable = true;
          entry = "${pkgs.bash}/bin/bash ${./check-governance.sh} .";
          pass_filenames = false;
          language = "system";
        };
        # State validity
        state = let
          python = pkgs.python3.withPackages (ps: [ps.jsonschema]);
        in {
          enable = true;
          entry = "${python}/bin/python ${./check-state.py} .";
          pass_filenames = false;
          language = "system";
        };
      };
    };
  };
}
