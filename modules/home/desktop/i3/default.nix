{
  lib,
  config,
  osConfig,
  pkgs,
  ...
}: let
  i3 = osConfig.my.nixos.desktop.i3;
  wallpaper = ../../../../assets/wallpaper-space1.png;
  font = {
    names = ["JetBrains Mono"];
    size = "13";
  };
  colors = {
    green = "#8a9a7b";
    gray = "#8b8792";
    muted = "#808080";
    red = "#c4746e";
    yellow = "#c4b28a";
    black = "#000000";
  };
in {
  options.my.home.desktop.i3.enable = lib.mkEnableOption "i3 user configuration";

  config = lib.mkMerge [
    {
      assertions = [
        {
          assertion = !i3.usei3Status || i3.enable;
          message = "my.nixos.desktop.i3.usei3Status requires my.nixos.desktop.i3.enable";
        }
      ];
    }

    (lib.mkIf (config.my.home.desktop.i3.enable && i3.enable) {
      services.picom = {
        enable = true;
        backend = "glx";
        vSync = true;
        settings = {
          blur-background = true;
          blur-background-fixed = true;
          blur-method = "dual_kawase";
          blur-strength = 4;
        };
      };

      systemd.user.services.xwallpaper = {
        Unit = {
          Description = "Set X11 wallpaper";
          PartOf = ["graphical-session.target"];
          Before = ["picom.service"];
        };
        Service = {
          Type = "oneshot";
          ExecStart = "${lib.getExe pkgs.xwallpaper} --zoom ${wallpaper}";
          RemainAfterExit = true;
        };
        Install.WantedBy = ["graphical-session.target"];
      };

      xsession.windowManager.i3 = {
        enable = true;
        config = {
          fonts = font;
          modifier = "Mod4";
          focus.followMouse = true;
          floating = {
            border = 2;
            modifier = "Mod4";
            titlebar = false;
          };
          window = {
            border = 2;
            hideEdgeBorders = "none";
            titlebar = false;
            commands = [
              {
                criteria.title = "coding";
                command = "floating enable, resize set 1200 900, move position center";
              }
            ];
          };
          colors = {
            background = colors.black;
            focused = {
              border = colors.gray;
              background = colors.black;
              text = colors.yellow;
              indicator = colors.gray;
              childBorder = colors.gray;
            };
            focusedInactive = {
              border = colors.gray;
              background = colors.black;
              text = colors.green;
              indicator = colors.gray;
              childBorder = colors.gray;
            };
            unfocused = {
              border = colors.gray;
              background = colors.black;
              text = colors.muted;
              indicator = colors.gray;
              childBorder = colors.gray;
            };
            urgent = {
              border = colors.red;
              background = colors.black;
              text = colors.red;
              indicator = colors.red;
              childBorder = colors.red;
            };
          };
          modes = lib.mkForce {};
          bars = lib.optionals i3.usei3Status [
            {
              fonts = font;
              position = "top";
              statusCommand = "${pkgs.i3status}/bin/i3status";
              trayOutput = "primary";
              colors = {
                background = colors.black;
                statusline = colors.green;
                separator = colors.muted;
                focusedWorkspace = {
                  border = colors.black;
                  background = colors.black;
                  text = colors.yellow;
                };
                activeWorkspace = {
                  border = colors.black;
                  background = colors.black;
                  text = colors.green;
                };
                inactiveWorkspace = {
                  border = colors.black;
                  background = colors.black;
                  text = colors.muted;
                };
                urgentWorkspace = {
                  border = colors.black;
                  background = colors.black;
                  text = colors.red;
                };
                bindingMode = {
                  border = colors.black;
                  background = colors.black;
                  text = colors.red;
                };
              };
              extraConfig = ''
                separator_symbol "|"
              '';
            }
          ];
          keybindings = lib.mkForce {
            XF86MonBrightnessUp = "exec --no-startup-id brightnessctl set +5%";
            XF86MonBrightnessDown = "exec --no-startup-id brightnessctl set 5%-";
            XF86AudioMute = "exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle";
            XF86AudioRaiseVolume = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +5%";
            XF86AudioLowerVolume = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -5%";
            XF86AudioMicMute = "exec --no-startup-id pactl set-source-mute @DEFAULT_SOURCE@ toggle";

            "Mod4+Return" = "exec --no-startup-id ghostty";
            "Mod4+m" = "exec --no-startup-id rofi -show drun -normal-window";
            "Mod4+f" = "exec --no-startup-id firefox";
            "Mod4+Shift+f" = "floating toggle";
            "Mod4+c" = "exec --no-startup-id ghostty --title=coding";
            "Mod4+Shift+q" = "kill";

            "Mod4+h" = "focus left";
            "Mod4+j" = "focus down";
            "Mod4+k" = "focus up";
            "Mod4+l" = "focus right";

            "Mod4+space" = "layout toggle split";
            "Mod4+Control+r" = "reload";

            "Mod4+1" = "workspace number 1";
            "Mod4+2" = "workspace number 2";
            "Mod4+3" = "workspace number 3";
            "Mod4+4" = "workspace number 4";
            "Mod4+5" = "workspace number 5";
            "Mod4+6" = "workspace number 6";
            "Mod4+7" = "workspace number 7";
            "Mod4+8" = "workspace number 8";
            "Mod4+9" = "workspace number 9";

            "Mod4+Shift+1" = "move container to workspace number 1";
            "Mod4+Shift+2" = "move container to workspace number 2";
            "Mod4+Shift+3" = "move container to workspace number 3";
            "Mod4+Shift+4" = "move container to workspace number 4";
            "Mod4+Shift+5" = "move container to workspace number 5";
            "Mod4+Shift+6" = "move container to workspace number 6";
            "Mod4+Shift+7" = "move container to workspace number 7";
            "Mod4+Shift+8" = "move container to workspace number 8";
            "Mod4+Shift+9" = "move container to workspace number 9";
          };
        };
      };
    })

    (lib.mkIf (config.my.home.desktop.i3.enable && i3.enable && i3.usei3Status) {
      programs.i3status = {
        enable = true;
        enableDefault = false;
        general = {
          output_format = "i3bar";
          markup = "pango";
          colors = true;
          interval = 2;
          color_good = colors.green;
          color_bad = colors.red;
          color_degraded = colors.yellow;
        };
        modules = {
          "tztime local" = {
            position = 1;
            settings.format = "<span color='${colors.yellow}'>%Y-%m-%d %H:%M</span>";
          };
          "volume master" = {
            position = 2;
            settings = {
              format = "VOL %volume";
              format_muted = "VOL muted";
              device = "default";
              mixer = "Master";
              mixer_idx = 0;
            };
          };
          "battery all" = {
            position = 3;
            settings = {
              format = "BAT %status %percentage";
              format_down = "BAT %status %percentage";
              threshold_type = "percentage";
              status_chr = "+";
              status_bat = "";
              status_full = "full";
              low_threshold = 15;
              integer_battery_capacity = true;
              hide_seconds = true;
            };
          };
          "wireless _first_" = {
            position = 4;
            settings = {
              format_up = "WIFI %quality";
              format_down = "WIFI down";
            };
          };
          cpu_usage = {
            position = 5;
            settings.format = "CPU %usage";
          };
          memory = {
            position = 6;
            settings = {
              format = "MEM %percentage_used";
              threshold_degraded = "50%";
              format_degraded = "MEM %percentage_used";
            };
          };
        };
      };
    })
  ];
}
