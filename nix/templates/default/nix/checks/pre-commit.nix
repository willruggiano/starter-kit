{
  pkgs,
  self,
  git-hooks,
  formatter,
}:
git-hooks.lib.${pkgs.stdenv.hostPlatform.system}.run {
  src = self;
  hooks = {
    # Formatting
    treefmt = {
      enable = true;
      package = formatter;
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
}
