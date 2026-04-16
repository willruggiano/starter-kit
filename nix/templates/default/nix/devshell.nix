{
  pkgs,
  pre-commit,
  formatter,
  claude-code,
}:
pkgs.mkShell {
  env = {};
  packages = [
    formatter
    claude-code
  ];
  shellHook = ''
    ${pre-commit.shellHook}
  '';
}
