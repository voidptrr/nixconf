{
  self,
  inputs,
  ...
}: let
  mkDarwinSystem = import ../../../lib/mkDarwinSystem.nix {
    inherit self inputs;
  };

  system = "aarch64-darwin";
  username = "voidptr";
in {
  flake.darwinConfigurations.personal = mkDarwinSystem {
    inherit system username;
    hostModule = self.hostModules.macbook-pro-m2;
  };
}
