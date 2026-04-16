{
  perSystem = {
    config,
    pkgs,
    ...
  }: {
    devShells.default = pkgs.mkShell {
      env = {};
      packages = [
        config.packages.claude-code
        config.packages.treefmt
      ];
      shellHook = ''
        ${config.pre-commit.shellHook}
      '';
    };
  };
}
