{
  inputs,
  lib,
  ...
}: {
  registry.homeManagerModules.firefox = {pkgs, ...}: {
    programs.firefox = {
      enable = true;
      package = lib.mkDefault (
        if pkgs.stdenv.hostPlatform.isDarwin
        then null
        else pkgs.firefox
      );
      policies = import ./_policies.nix;
      profiles.default = {
        name = "voidptr";
        bookmarks = {
          force = true;
          settings = [
            {
              toolbar = true;
              bookmarks = [
                {
                  name = "GitHub";
                  url = "https://github.com/";
                }
              ];
            }
          ];
        };
        extensions.packages = with inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
          ublock-origin
          proton-pass
        ];
        search = {
          force = true;
          default = "ddg";
          order = ["ddg"];
          engines = {
            "nix-packages" = {
              definedAliases = ["@n" "@nix"];
              urls = [
                {
                  template = "https://search.nixos.org/packages";
                  params = [
                    {
                      name = "type";
                      value = "packages";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
            };
            "home-manager-options" = {
              definedAliases = ["@homemanager" "@hm"];
              urls = [
                {
                  template = "https://home-manager-options.extranix.com";
                  params = [
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
            };
            "youtube" = {
              definedAliases = ["@yt"];
              urls = [
                {
                  template = "https://www.youtube.com/results";
                  params = [
                    {
                      name = "search_query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
            };
          };
        };
      };
    };
  };
}
