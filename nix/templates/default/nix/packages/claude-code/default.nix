{inputs, ...}: {
  perSystem = {
    config,
    inputs',
    pkgs,
    system,
    ...
  }: {
    jail = {
      git.user.email = "noreply@anthropic.com";

      programs.claude = {
        package = inputs.agents.packages.${system}.claude-code;
        additionalCombinators = cs:
          with cs; [
            gui
            (add-pkg-deps [
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
    };

    apps.claude-code = {
      type = "app";
      program = pkgs.lib.getExe config.packages.claude-code;
      meta.description = config.packages.claude-code.name;
    };

    packages = {
      claude-code = let
        drv = config.jail.programs.claude.build.wrapped;
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
