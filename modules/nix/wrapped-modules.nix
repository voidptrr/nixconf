{self, ...}: {
  flake.nixModules.wrappedModules = {
    config,
    lib,
    pkgs,
    ...
  }: let
    wrappedPkgs = self.packages.${pkgs.stdenv.hostPlatform.system};
    cfg = config.shared;
  in {
    options = {
      shared = {
        packages = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [];
          description = "Names from self.packages to add to environment.systemPackages.";
        };
      };
    };

    config = {
      environment.systemPackages = map (name: wrappedPkgs.${name}) cfg.packages;
    };
  };
}
