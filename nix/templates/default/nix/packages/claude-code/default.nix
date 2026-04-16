{
  config,
  inputs,
  ...
}: let
  inherit (config.flake) lib;
in {
  perSystem = {
    config,
    inputs',
    pkgs,
    system,
    ...
  }: {
    apps.claude-code = {
      type = "app";
      program = pkgs.lib.getExe config.packages.claude-code;
      meta.description = config.packages.claude-code.name;
    };

    packages = {
      claude-code = let
        drv = lib.mkJailed {
          inherit pkgs;
          package = inputs.agents.packages.${system}.claude-code;
          name = "claude";
          replyTo = "noreply@anthropic.com";
          additionalCombinators = cs:
            with cs; [
              (add-pkg-deps [
                config.packages.treefmt
                pkgs.sox
              ])
              (readwrite (noescape "~/.claude"))
              (readwrite (noescape "~/.claude.json"))
              (set-env "CLAUDE_CODE_EFFORT_LEVEL" "max")
              (set-env "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS" "1")
              (wrap-entry (entry: ''
                # The program is already sandboxed. For this reason we opt to
                # start in this mode to facilitate rapid iteration.
                ${entry} --allow-dangerously-skip-permissions --dangerously-skip-permissions
              ''))
            ];
        };
      in
        drv
        // {
          name = "${config.packages.claude-code-unwrapped.name}-jailed";
          unjailed = config.packages.claude-code-unwrapped;
        };

      claude-code-unwrapped = inputs'.agents.packages.claude-code;
    };
  };
}
