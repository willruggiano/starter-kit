{inputs, ...}: {
  imports = [
    inputs.git-hooks.flakeModule
  ];
  perSystem = {
    config,
    pkgs,
    ...
  }: {
    jail.additionalCombinators = cs:
      with cs; [
        (add-pkg-deps [config.pre-commit.settings.package])
        (ro-bind config.pre-commit.settings.configPath config.pre-commit.settings.configFile)
      ];

    pre-commit.settings = {
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
