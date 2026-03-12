{lib, ...}: {
  flake.darwinModules.git = {config, ...}: let
    gitConfigText =
      lib.replaceStrings ["@GIT_SIGNING_KEY@"] [config.darwin.sops.gitSigningKeyPath] (builtins.readFile ./gitconfig);
  in {
    config = {
      environment.etc."gitconfig".text = gitConfigText;
      environment.variables.GIT_CONFIG_GLOBAL = "/etc/gitconfig";
    };
  };

  perSystem = {pkgs, ...}: {
    packages.git = pkgs.git;
  };
}
