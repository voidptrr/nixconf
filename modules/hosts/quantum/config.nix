{self, ...}: {
  flake.darwinModules.quantum = {pkgs, ...}: let
    ghosttyBin = "${self.packages.${pkgs.stdenv.hostPlatform.system}.ghostty}/bin/ghostty";
  in {
    environment.systemPackages = with self.packages.${pkgs.stdenv.hostPlatform.system}; [
      ghostty
      zsh-wrapped
      tmux
      nvim
      ptx
    ];

    services.skhd = {
      enable = true;
      skhdConfig = ''
        cmd - g : ${ghosttyBin}
        cmd - b : /usr/bin/open -a "Firefox"
      '';
    };

    homebrewConfig = {
      brews = ["mole"];
      casks = ["firefox"];
      masApps = {
        KakaoTalk = 869223134;
      };
    };
    dockConfig.persistentApps = map (app: {inherit app;}) [
      "/System/Applications/Music.app"
      "/Applications/Kakaotalk.app"
      "/Applications/Firefox.app"
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
