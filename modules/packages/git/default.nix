{...}: {
  flake.nixModules.git = {
    config,
    lib,
    pkgs,
    ...
  }: let
    cfg = config.shared.git;

    gitConfigFile = (pkgs.formats.gitIni {}).generate "gitconfig" {
      user = {
        name = cfg.name;
        email = cfg.email;
        signingkey = cfg.signingKeyPath;
      };
      push.autoSetupRemote = true;
      init.defaultBranch = "main";
      pull.rebase = true;
      gpg.format = "ssh";
      commit.gpgSign = true;
    };
  in {
    options.shared.git = {
      name = lib.mkOption {
        type = lib.types.nonEmptyStr;
      };

      email = lib.mkOption {
        type = lib.types.nonEmptyStr;
      };

      signingKeyPath = lib.mkOption {
        type = lib.types.nonEmptyStr;
        description = "Absolute path to the SSH signing key used by git.";
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
