{self, ...}: {
  registry.hostModules.macbook-pro-m2 = {
    pkgs,
    config,
    ...
  }: let
    ghosttyBin = "${self.packages.${pkgs.stdenv.hostPlatform.system}.ghostty}/bin/ghostty";
  in {
    imports = [self.hostModules.macbook-pro-m2-secrets];

    shared = {
      packages = [
        "ghostty"
        "zsh"
        "tmux"
        "nvim"
        "ptx"
        "git"
        "opencode"
      ];

      git = {
        name = "voidptrr";
        email = "bruno.tommaso@protonmail.com";
        signingKeyPath = config.sops.secrets.git-signing-key.path;
      };
    };

    darwin = {
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

      dock.persistentApps = [
        "/System/Applications/Music.app"
        "/Applications/Kakaotalk.app"
        "/Applications/Firefox.app"
      ];
    };
  };
}
