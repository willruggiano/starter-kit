{
  inputs,
  perSystem,
  pkgs,
  ...
}: let
  inherit (inputs.self.checks.${pkgs.stdenv.hostPlatform.system}) pre-commit;
in
  pkgs.mkShell {
    env = {};
    packages = [
      perSystem.self.formatter
      perSystem.self.claude-code
    ];
    shellHook = ''
      ${pre-commit.shellHook}
    '';
  }
