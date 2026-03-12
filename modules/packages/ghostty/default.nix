{self, ...}: {
  perSystem = {pkgs, ...}: let
    baseGhostty =
      if pkgs.stdenv.hostPlatform.isDarwin
      then pkgs.ghostty-bin
      else pkgs.ghostty;

    ghosttyFlags =
      [
        "--maximize=true"
        "--working-directory=home"
        "--window-inherit-working-directory=false"
        "--command=${self.packages.${pkgs.stdenv.hostPlatform.system}.zsh-wrapped}/bin/zsh"
      ]
      ++ pkgs.lib.optionals pkgs.stdenv.hostPlatform.isLinux [
        "--window-decoration=none"
      ]
      ++ pkgs.lib.optionals pkgs.stdenv.hostPlatform.isDarwin [
        "--macos-titlebar-style=hidden"
        "--macos-icon=chalkboard"
      ];

    wrappedFlags = pkgs.lib.concatStringsSep " " ghosttyFlags;
  in {
    packages.ghostty = pkgs.symlinkJoin {
      name = "ghostty-wrapped";
      paths = [baseGhostty];

      buildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram "$out/bin/ghostty" --add-flags "${wrappedFlags}"
      '';
    };
  };
}
