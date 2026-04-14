{
  inputs,
  pkgs,
  ...
}:
pkgs.runCommand "governance-check" {
  src = inputs.self;
  nativeBuildInputs = [pkgs.bash];
} ''
  bash ${./governance.sh} "$src"
  touch "$out"
''
