{
  pkgs,
  self,
}:
pkgs.runCommand "governance-check" {
  src = self;
  nativeBuildInputs = [pkgs.bash];
} ''
  bash ${./governance.sh} "$src"
  touch "$out"
''
