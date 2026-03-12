{
  self,
  inputs,
  ...
}: let
  system = "aarch64-darwin";
  username = "voidptr";

  darwinModules = builtins.attrValues self.darwinModules;
  homeModules = builtins.attrValues self.homeManagerModules;
in {
  flake.darwinConfigurations.personal = inputs.nix-darwin.lib.darwinSystem {
    inherit system;
    specialArgs = {
      inherit username;
      homeManagerModules = homeModules;
    };
    modules =
      darwinModules
      ++ [
        self.hostModules.quantum
        self.nixModules.base
      ]
      ++ [
        inputs.nix-homebrew.darwinModules.nix-homebrew
        inputs.home-manager.darwinModules.home-manager
      ];
  };
}
