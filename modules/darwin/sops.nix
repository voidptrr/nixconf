{
  inputs,
  lib,
  ...
}: {
  flake.darwinModules.sops = {
    config,
    username,
    ...
  }: {
    imports = [inputs.sops-nix.darwinModules.sops];

    options.darwin.sops = {
      defaultSopsFile = lib.mkOption {
        type = lib.types.path;
        default = ../../secrets/secrets.yaml;
      };

      ageKeyFile = lib.mkOption {
        type = lib.types.str;
        default = "/Users/${username}/sops/age/keys.txt";
      };
    };

    config.sops = {
      defaultSopsFile = config.darwin.sops.defaultSopsFile;
      gnupg.sshKeyPaths = lib.mkForce [];
      age = {
        keyFile = config.darwin.sops.ageKeyFile;
        sshKeyPaths = lib.mkForce [];
      };
    };
  };
}
