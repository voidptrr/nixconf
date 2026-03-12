{lib, ...}: {
  flake.darwinModules.skhd = {config, ...}: let
    cfg = config.darwin.skhd;
  in {
    options.darwin.skhd = {
      enable = lib.mkEnableOption "skhd hotkey daemon";
      config = lib.mkOption {
        type = lib.types.lines;
        default = "";
      };
    };

    config = lib.mkIf cfg.enable {
      services.skhd = {
        enable = true;
        skhdConfig = cfg.config;
      };
    };
  };
}
