{lib, ...}: {
  flake.nixModules.base = {pkgs, ...}: {
    nix =
      {
        enable = pkgs.stdenv.hostPlatform.isLinux;
      }
      // lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
        settings = {
          auto-optimise-store = true;
          warn-dirty = false;
        };
        gc = {
          automatic = true;
          interval = {
            Hour = 3;
            Minute = 15;
          };
          options = "--delete-older-than 5d";
        };
      };
  };
}
