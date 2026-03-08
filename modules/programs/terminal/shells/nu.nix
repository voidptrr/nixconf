{...}: {
  flake.homeManagerModules.nu = {
    config,
    lib,
    ...
  }: let
    cfg = config.programs.shellProfile;
  in {
    programs.nushell = {
      enable = true;

      shellAliases =
        cfg.shellAliases
        // {
          nd = "nix develop -c nu";
        };

      environmentVariables = cfg.environmentVariables;

      settings = {
        cursor_shape = {
          emacs = "line";
          vi_insert = "line";
          vi_normal = "line";
        };
      };

      extraConfig = lib.mkOrder 500 ''
        $env.PROMPT_COMMAND_RIGHT = ""
        $env.PROMPT_INDICATOR = " % "
        $env.PROMPT_INDICATOR_VI_INSERT = " % "
        $env.PROMPT_INDICATOR_VI_NORMAL = " % "
        $env.PROMPT_MULTILINE_INDICATOR = "::: "
        $env.PROMPT_COMMAND = {||
          let branch = (do -i { ^git rev-parse --abbrev-ref HEAD | str trim })
          let in_nix = ($env | columns | any {|it| $it == "IN_NIX_SHELL" })
          let cwd = (pwd)
          let cwd_short = if ($cwd | str starts-with $env.HOME) {
            $cwd | str replace $env.HOME "~"
          } else {
            $cwd
          }
          let path_part = $"(ansi yellow)($cwd_short)(ansi reset)"
          let branch_part = if ($branch | is-empty) {
            ""
          } else {
            $" (ansi dark_gray)*($branch)(ansi reset)"
          }
          let nix_part = if $in_nix {
            $" (ansi blue_dimmed)" + "(nix)" + $"(ansi reset)"
          } else {
            ""
          }

          $"($path_part)($branch_part)($nix_part)"
        }
      '';
    };
  };
}
