{lib, ...}: {
  flake.darwinModules.homebrew = {
    username,
    config,
    ...
  }: let
    cfg = config.darwin.homebrew;
  in {
    options.darwin.homebrew = {
      brews = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
      };
      casks = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
      };
      masApps = lib.mkOption {
        type = lib.types.attrsOf lib.types.int;
        default = {};
      };
    };

    config = {
      nix-homebrew = {
        enable = true;
        enableRosetta = true;
        user = username;
      };

      homebrew = {
        enable = true;
        onActivation = {
          autoUpdate = true;
          upgrade = true;
          cleanup = "zap";
        };

        brews = cfg.brews;
        casks = cfg.casks;
        masApps = cfg.masApps;
      };
    };
  };
}
