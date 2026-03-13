{
  description = "System configuration infrastructure for my machines";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    import-tree.url = "github:vic/import-tree";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";

    firefox-addons.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
  };

  outputs = {...} @ inputs: let
    lib = inputs.nixpkgs.lib;
  in
    inputs.flake-parts.lib.mkFlake {inherit inputs;}
    {
      imports = [
        (inputs.import-tree ./modules)
      ];

      options = {
        flake.darwinModules = lib.mkOption {
          type = lib.types.attrsOf lib.types.raw;
          default = {};
          description = "Registry of nix-darwin modules.";
        };
        flake.homeManagerModules = lib.mkOption {
          type = lib.types.attrsOf lib.types.raw;
          default = {};
          description = "Registry of Home Manager modules.";
        };
        flake.nixModules = lib.mkOption {
          type = lib.types.attrsOf lib.types.raw;
          default = {};
          description = "Registry of shared Nix modules.";
        };
        flake.hostModules = lib.mkOption {
          type = lib.types.attrsOf lib.types.raw;
          default = {};
          description = "Registry of host-specific modules.";
        };
      };

      config = {
        systems = ["aarch64-darwin"];
        perSystem = {pkgs, ...}: {
          formatter = pkgs.alejandra;
          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              age
              sops
            ];

            shellHook = ''
              export SOPS_AGE_KEY_FILE="$HOME/sops/age/keys.txt"
            '';
          };
          checks = {
            checks = pkgs.runCommand "checks" {} ''
              cd ${./.}
              ${pkgs.alejandra}/bin/alejandra --check .
              ${pkgs.shellcheck}/bin/shellcheck setup.sh
              touch $out
            '';
          };
        };
      };
    };
}
