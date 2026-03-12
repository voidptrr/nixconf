{self, ...}: {
  flake.darwinModules.wrapped-packages = {
    config,
    lib,
    pkgs,
    ...
  }: let
    cfg = config.darwin;
    wrappedPkgs = self.packages.${pkgs.stdenv.hostPlatform.system};
  in {
    options.darwin.wrappedPackages = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Names of wrapped packages to add to environment.systemPackages.";
    };

    config.environment.systemPackages =
      map (name: wrappedPkgs.${name}) cfg.wrappedPackages;
  };
}
