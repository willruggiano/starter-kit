{
  description = "Project starter — Nix-native solo dev with coding agents";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixpkgs-unstable";
    agents = {
      url = "github:numtide/llm-agents.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    jail = {
      url = "sourcehut:~alexdavid/jail.nix";
    };
    treefmt = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    agents,
    jail,
    treefmt,
    git-hooks,
    ...
  }: let
    systems = ["x86_64-linux"];
    eachSystem = f:
      nixpkgs.lib.genAttrs systems (system:
        f nixpkgs.legacyPackages.${system});
  in {
    formatter =
      eachSystem (pkgs:
        import ./nix/formatter.nix {inherit pkgs treefmt;});

    packages = eachSystem (pkgs: let
      lib = import ./nix/lib/default.nix {inherit jail;};
      formatter = self.formatter.${pkgs.stdenv.hostPlatform.system};
      claude-code = import ./nix/packages/claude-code/default.nix {
        inherit pkgs lib formatter;
        agents-claude-code = agents.packages.${pkgs.stdenv.hostPlatform.system}.claude-code;
      };
    in {
      inherit formatter claude-code;
    });

    checks = eachSystem (pkgs: let
      inherit (pkgs.stdenv.hostPlatform) system;
    in {
      pre-commit = import ./nix/checks/pre-commit.nix {
        inherit pkgs self git-hooks;
        inherit (self.packages.${system}) formatter;
      };
      state = import ./nix/checks/state.nix {inherit pkgs self;};
      governance = import ./nix/checks/governance.nix {inherit pkgs self;};
    });

    devShells = eachSystem (pkgs: let
      inherit (pkgs.stdenv.hostPlatform) system;
    in {
      default = import ./nix/devshell.nix {
        inherit pkgs;
        inherit (self.packages.${system}) claude-code;
        inherit (self.packages.${system}) formatter;
        inherit (self.packages.${system}) pre-commit;
      };
    });

    apps = eachSystem (pkgs: let
      inherit (pkgs.stdenv.hostPlatform) system;
    in {
      claude-code = {
        type = "app";
        program = nixpkgs.lib.getExe self.packages.${system}.claude-code;
      };
    });
  };
}
