{inputs, ...}: {
  imports = [
    inputs.treefmt.flakeModule
  ];

  perSystem = {
    config,
    lib,
    ...
  }: {
    jail.additionalCombinators = cs:
      with cs; [
        (add-pkg-deps [config.packages.treefmt])
      ];

    packages.treefmt = config.treefmt.build.wrapper;

    treefmt = {
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
    };
  };
}
