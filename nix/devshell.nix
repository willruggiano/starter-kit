{
  inputs,
  pkgs,
  ...
}: let
  inherit (inputs.self.checks.${pkgs.stdenv.hostPlatform.system}) pre-commit;
in
  pkgs.mkShell {
    env = {};
    packages = [];
    shellHook = ''
      ${pre-commit.shellHook}
    '';
  }
