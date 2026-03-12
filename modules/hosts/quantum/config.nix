{self, ...}: {
  flake.darwinModules.quantum = {pkgs, ...}: let
    ghosttyBin = "${self.packages.${pkgs.stdenv.hostPlatform.system}.ghostty}/bin/ghostty";
  in {
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.ghostty
      self.packages.${pkgs.stdenv.hostPlatform.system}.zsh-wrapped
      self.packages.${pkgs.stdenv.hostPlatform.system}.tmux
      self.packages.${pkgs.stdenv.hostPlatform.system}.nvim
    ];

    services.skhd = {
      enable = true;
      skhdConfig = ''
        cmd - g : ${ghosttyBin}
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
