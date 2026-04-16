{
  description = "Nix-native agentic development starter kit";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixpkgs-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
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

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];

      imports = [
        ./nix/jailed.nix
        ./nix/formatter.nix
        ./nix/packages
        ./nix/checks
        ./nix/devshell.nix
      ];

      flake.templates.default = {
        description = "Nix-native agentic development starter kit";
        path = ./nix/templates/default;
      };
    };
}
