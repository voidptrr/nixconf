{...}: {
  flake.homeManagerModules.tmux = {pkgs, ...}: {
    programs.tmux = {
      enable = true;
      prefix = "C-a";
      terminal = "screen-256color";
      focusEvents = true;
      historyLimit = 5000;
      mouse = true;
      keyMode = "vi";
      escapeTime = 0;
      shell = "${pkgs.zsh}/bin/zsh";
      plugins = [
        {
          plugin = pkgs.tmuxPlugins.prefix-highlight;
          extraConfig = ''
            set -g @prefix_highlight_show_copy_mode 'on'
            set -g @prefix_highlight_copy_mode_attr 'fg=black,bg=yellow,bold'
            set -g @prefix_highlight_show_sync_mode 'on'
            set -g @prefix_highlight_sync_mode_attr 'fg=black,bg=green'
          '';
        }
        {
          plugin = pkgs.tmuxPlugins.fzf-tmux-url;
        }
      ];
      extraConfig = ''
        set -g status-style 'fg=#d3c6aa,bg=#272e33'
        set -g message-style 'fg=#d3c6aa,bg=#374145'
        set -g pane-border-style 'fg=#414b50'
        set -g pane-active-border-style 'fg=#83c092'
        set -g window-status-current-style 'fg=#272e33,bg=#a7c080,bold'
        set -g window-status-style 'fg=#9da9a0,bg=#272e33'

        set-hook -g after-new-session 'if-shell -F "#{==:#{window_panes},1}" "split-window -h -c \"#{pane_current_path}\"; select-pane -L; resize-pane -R 15"'

        bind '"' split-window -c "#{pane_current_path}"
        bind '%' split-window -c "#{pane_current_path}" -h
        bind 'c' new-window -c "#{pane_current_path}"

        bind w switch-client -T window-nav
        bind -T window-nav h select-pane -L \; switch-client -T prefix
        bind -T window-nav l select-pane -R \; switch-client -T prefix
        bind -T window-nav Escape switch-client -T prefix

        bind -r h resize-pane -L 5
        bind -r j resize-pane -D 5
        bind -r k resize-pane -U 5
        bind -r l resize-pane -R 5

        bind R source-file ~/.config/tmux/tmux.conf
      '';
    };
  };
}
