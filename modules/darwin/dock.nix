{lib, ...}: {
  flake.darwinModules.dock = {config, ...}: let
    cfg = config.darwin.dock;
  in {
    options.darwin.dock.persistentApps = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
    };

    config.system.defaults.dock = {
      autohide = true;
      launchanim = false;
      magnification = false;
      minimize-to-application = true;
      mineffect = null;
      orientation = "bottom";
      persistent-apps = map (app: {inherit app;}) cfg.persistentApps;
      show-recents = false;
      tilesize = 48;
    };
  };
}
