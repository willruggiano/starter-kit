{inputs, ...}: {
  perSystem = {
    config,
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
      };
    };
  };
}
