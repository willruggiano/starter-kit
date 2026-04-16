{inputs, ...}: {
  flake.lib.mkJailed = {
    pkgs,
    package,
    replyTo,
    additionalCombinators,
    name ? package.pname,
  }: let
    jail = inputs.jail.lib.extend {
      inherit pkgs;
      basePermissions = cs:
        with cs; [
          base
          bind-nix-store-runtime-closure
          fake-passwd
          gpu
          gui
          mount-cwd
          network
          open-urls-in-browser
          time-zone
          (add-pkg-deps (with pkgs; [
            bash
            coreutils
            curl
            diffutils
            fd
            file
            findutils
            gawk
            git
            gnugrep
            gnused
            gnutar
            gzip
            jq
            less
            patch
            python3
            python3.pkgs.ddgs # web search tool
            ripgrep
            sd
            tree
            unzip
            wget
            which
          ]))
          (set-env "GIT_AUTHOR_EMAIL" replyTo)
          (set-env "GIT_COMMITTER_EMAIL" replyTo)
          (set-env "SHELL" (pkgs.lib.getExe pkgs.bash))
        ];
    };
  in
    jail name package additionalCombinators;
}
