{...}: {
  perSystem = {pkgs, ...}: {
    packages.zsh-wrapped = let
      zshrc = pkgs.writeText ".zshrc" ''
        alias ll='ls -la'
        alias nd='nix develop -c zsh'

        if [[ "$OSTYPE" == darwin* ]]; then
          alias rebuild='sudo darwin-rebuild switch --flake ~/git/dotfiles#personal'
        else
          alias rebuild='sudo nixos-rebuild switch'
        fi

        autoload -Uz vcs_info
        zstyle ':vcs_info:git:*' formats '*%b'

        precmd() {
          vcs_info

          local nix_part=""
          if [ -n "''${IN_NIX_SHELL-}" ]; then
            nix_part="%F{4}(nix)%f"
          fi

          PROMPT="%F{yellow}%~%f"

          if [ -n "''${vcs_info_msg_0_-}" ]; then
            PROMPT+=" %F{242}''${vcs_info_msg_0_-}%f"
          fi

          if [ -n "$nix_part" ]; then
            PROMPT+=" $nix_part"
          fi

          PROMPT+=" %% "
        }
      '';

      zshenv = pkgs.writeText ".zshenv" ''
        export EDITOR="nvim"
        export BROWSER="firefox"
        export TERMINAL="ghostty"
      '';

      zshDotDir = toString (
        pkgs.linkFarm "zsh-merged-config" [
          {
            name = ".zshrc";
            path = zshrc;
          }
          {
            name = ".zshenv";
            path = zshenv;
          }
        ]
      );
    in
      pkgs.symlinkJoin {
        name = "zsh-wrapped";
        paths = [pkgs.zsh];
        buildInputs = [pkgs.makeWrapper];
        postBuild = ''
          wrapProgram "$out/bin/zsh" --set ZDOTDIR "${zshDotDir}"
        '';
      };
  };
}
