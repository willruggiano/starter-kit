{
  pkgs,
  lib,
  formatter,
  agents-claude-code,
}: let
  pkg = lib.mkJailed {
    inherit pkgs;
    package = agents-claude-code;
    name = "claude";
    replyTo = "noreply@anthropic.com";
    additionalCombinators = cs:
      with cs; [
        (add-pkg-deps [
          formatter
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
  pkg
  // {
    unwrapped = agents-claude-code;
  }
