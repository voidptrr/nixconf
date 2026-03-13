{...}: {
  perSystem = {pkgs, ...}: {
    packages.opencode = pkgs.symlinkJoin {
      name = "opencode";
      paths = [pkgs.opencode];
      buildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram "$out/bin/opencode" --set OPENCODE_CONFIG "${./opencode.json}"
      '';
    };
  };
}
