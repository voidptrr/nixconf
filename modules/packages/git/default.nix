{...}: {
  flake.darwinModules.git = {
    config,
    lib,
    pkgs,
    ...
  }: let
    cfg = config.darwin.git;

    gitConfigFile = (pkgs.formats.gitIni {}).generate "gitconfig" {
      user = {
        name = cfg.name;
        email = cfg.email;
        signingkey = config.darwin.sops.gitSigningKeyPath;
      };
      push.autoSetupRemote = true;
      init.defaultBranch = "main";
      pull.rebase = true;
      gpg.format = "ssh";
      commit.gpgSign = true;
    };
  in {
    options.darwin.git = {
      name = lib.mkOption {
        type = lib.types.nonEmptyStr;
      };

      email = lib.mkOption {
        type = lib.types.nonEmptyStr;
      };
    };

    config = {
      environment.etc."gitconfig".source = gitConfigFile;
      environment.variables.GIT_CONFIG_GLOBAL = "/etc/gitconfig";
    };
  };

  perSystem = {pkgs, ...}: {
    packages.git = pkgs.symlinkJoin {
      name = "git";
      paths = [pkgs.git];
      buildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram "$out/bin/git" --set GIT_CONFIG_GLOBAL "/etc/gitconfig"
      '';
    };
  };
}
