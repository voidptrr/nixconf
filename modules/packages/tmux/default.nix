{self, ...}: {
  perSystem = {pkgs, ...}: let
    zshBin = "${self.packages.${pkgs.stdenv.hostPlatform.system}.zsh-wrapped}/bin/zsh";

    tmuxConfig = pkgs.writeText "tmux.conf" ''
      set -g prefix `
      unbind C-b
      bind ` send-prefix

      set -g default-terminal "screen-256color"
      set -g focus-events on
      set -g history-limit 5000
      set -g mouse on
      setw -g mode-keys vi
      set -sg escape-time 0

      set -g default-shell "${zshBin}"
      set -g default-command "${zshBin}"

      set -g base-index 1
      set -g pane-base-index 1

      set -g status-style 'fg=#d3c6aa,bg=#272e33'
      set -g status-justify left
      set -g message-style 'fg=#d3c6aa,bg=#374145'
      set -g pane-border-style 'fg=#4f5b58'
      set -g pane-active-border-style 'fg=#d8a657'
      set -g window-status-current-style 'fg=#272e33,bg=#d8a657,bold'
      set -g window-status-style 'fg=#9da9a0,bg=#272e33'
      set -g window-status-separator ""
      set -g window-status-format '   #I   '
      set -g window-status-current-format '   #I   '
      set -g status-left ""
      set -g status-right ""

      set-hook -g after-new-session 'if-shell -F "#{==:#{window_panes},1}" "split-window -h -c \"#{pane_current_path}\"; select-pane -L; resize-pane -R 15"'

      bind '"' split-window -c "#{pane_current_path}"
      bind '%' split-window -c "#{pane_current_path}" -h
      bind 'c' new-window -c "#{pane_current_path}"
    '';
  in {
    packages.tmux = pkgs.symlinkJoin {
      name = "tmux";
      paths = [pkgs.tmux];
      buildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram "$out/bin/tmux" --add-flags "-f ${tmuxConfig}"
      '';
    };
  };
}
