{...}: {
  flake.homeManagerModules.zsh = {
    lib,
    config,
    ...
  }: let
    cfg = config.programs.shellProfile;
  in {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      sessionVariables = cfg.environmentVariables;
      shellAliases =
        cfg.shellAliases
        // {
          nd = "nix develop -c zsh";
        };

      initContent = lib.mkOrder 500 ''
        autoload -Uz vcs_info
        zstyle ':vcs_info:git:*' formats '*%b'

        precmd() {
          vcs_info

          local nix_part=""
          if [ -n "''${IN_NIX_SHELL-}" ]; then
            nix_part="%F{4}(nix)%f"
          fi

          PROMPT="%F{yellow}%~%f"

          if [ -n "''${vcs_info_msg_0_}" ]; then
            PROMPT+=" %F{242}''${vcs_info_msg_0_}%f"
          fi

          if [ -n "$nix_part" ]; then
            PROMPT+=" $nix_part"
          fi

          PROMPT+=" %% "
        }
      '';
    };
  };
}
