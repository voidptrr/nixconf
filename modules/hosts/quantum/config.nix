{...}: {
  flake.darwinModules.quantum = {...}: {
    homebrewConfig = {
      brews = ["mole"];
      casks = [
        "firefox"
        "ghostty"
      ];
      masApps = {
        KakaoTalk = 869223134;
      };
    };
    dockConfig.persistentApps = map (app: {inherit app;}) [
      "/System/Applications/Music.app"
      "/Applications/Kakaotalk.app"
      "/Applications/Firefox.app"
      "/Applications/Ghostty.app"
    ];
    home-manager.sharedModules = [
      {
        programs = {
          gitProfile = {
            name = "voidptrr";
            email = "bruno.tommaso@protonmail.com";
          };
        };
      }
    ];
  };
}
