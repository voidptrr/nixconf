{...}: {
  flake.homeManagerModules.ghostty = {
    lib,
    pkgs,
    ...
  }: {
    programs.ghostty = {
      enable = true;
      package =
        if pkgs.stdenv.hostPlatform.isLinux
        then pkgs.ghostty
        else null;

      enableZshIntegration = true;

      settings =
        {
          font-size = 15;
          font-thicken = true;
          font-thicken-strength = 100;
          font-family = "Source Code Pro";

          theme = "Everforest Dark Hard";
          background = "#292c33";
          maximize = true;
        }
        // lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
          window-decoration = "none";
        }
        // lib.optionalAttrs pkgs.stdenv.hostPlatform.isDarwin {
          macos-titlebar-style = "hidden";
          macos-icon = "chalkboard";
        };
    };
  };
}
