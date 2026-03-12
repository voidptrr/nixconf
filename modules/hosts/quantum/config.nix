{self, ...}: {
  flake.hostModules.quantum = {pkgs, ...}: let
    ghosttyBin = "${self.packages.${pkgs.stdenv.hostPlatform.system}.ghostty}/bin/ghostty";
  in {
    darwin = {
      wrappedPackages = [
        "ghostty"
        "zsh"
        "tmux"
        "nvim"
        "ptx"
        "git"
      ];

      skhd = {
        enable = true;
        config = ''
          cmd - g : ${ghosttyBin}
          cmd - b : /usr/bin/open -a "Firefox"
        '';
      };

      homebrew = {
        brews = ["mole"];
        casks = ["firefox"];
        masApps = {
          KakaoTalk = 869223134;
        };
      };

      git = {
        name = "voidptrr";
        email = "bruno.tommaso@protonmail.com";
      };

      dock.persistentApps = [
        "/System/Applications/Music.app"
        "/Applications/Kakaotalk.app"
        "/Applications/Firefox.app"
      ];
    };
  };
}
