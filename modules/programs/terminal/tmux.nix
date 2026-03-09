{...}: {
  flake.homeManagerModules.tmux = {pkgs, ...}: {
    programs.tmux = {
      enable = true;
      prefix = "`";
      terminal = "screen-256color";
      focusEvents = true;
      historyLimit = 5000;
      mouse = true;
      keyMode = "vi";
      escapeTime = 0;
      shell = "${pkgs.nushell}/bin/nu";
      extraConfig = ''
        set -g base-index 1
        set -g pane-base-index 1

        set -g status-style 'fg=#d3c6aa,bg=#272e33'
        set -g status-justify left 
        set -g message-style 'fg=#d3c6aa,bg=#374145'
        set -g pane-border-style 'fg=#414b50'
        set -g pane-active-border-style 'fg=#83c092'
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
    };
  };
}
