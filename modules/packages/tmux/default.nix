{self, ...}: {
  perSystem = {
    lib,
    pkgs,
    ...
  }: let
    zshBin = "${self.packages.${pkgs.stdenv.hostPlatform.system}.zsh}/bin/zsh";

    tmuxConfig = pkgs.writeText "tmux.conf" (
      lib.replaceStrings ["@ZSH_BIN@"] [zshBin] (builtins.readFile ./tmux.conf)
    );
  in {
    packages.tmux = pkgs.symlinkJoin {
      name = "tmux";
      paths = [pkgs.tmux];
      buildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram "$out/bin/tmux" --add-flags "-f ${tmuxConfig}"
      '';
    };
  };
}
