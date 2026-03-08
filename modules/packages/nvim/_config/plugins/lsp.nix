{
  plugins.lsp = let
    externalServer = {
      enable = true;
      package = null;
    };
  in {
    enable = true;
    keymaps = {
      lspBuf = {
        "K" = "hover";
        "<leader>ld" = "definition";
        "<leader>li" = "implementation";
        "<leader>lr" = "rename";
        "<leader>lc" = "code_action";
      };
    };
    servers = {
      nixd = {
        enable = true;
        settings = {
          formatting.command = ["alejandra"];
          nixpkgs.expr = "import <nixpkgs> {}";
          options = {
            darwin.expr = "(builtins.getFlake \"/private/etc/nix-darwin\").darwinConfigurations.personal.options";
            "home-manager".expr = "(builtins.getFlake \"/private/etc/nix-darwin\").darwinConfigurations.personal.options.home-manager";
          };
        };
      };

      yamlls = {
        enable = true;
        settings = {
          schemaStore.enable = true;
          validate = true;
          format.enable = true;
          yaml = {
            schemas = {
              kubernetes = "*.yaml";
              "http://json.schemastore.org/github-workflow" = ".github/workflows/*";
              "http://json.schemastore.org/github-action" = ".github/action.{yml,yaml}";
              "http://json.schemastore.org/kustomization" = "kustomization.{yml,yaml}";
              "http://json.schemastore.org/chart" = "Chart.{yml,yaml}";
              "https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json" = "*docker-compose*.{yml,yaml}";
            };
          };
        };
      };

      rust_analyzer =
        externalServer
        // {
          installCargo = false;
          installRustc = false;
        };

      clangd = externalServer;
      ts_ls = externalServer;
      zls = externalServer;
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>d";
      action = "<cmd>lua vim.diagnostic.setqflist(); vim.cmd('copen')<cr>";
      options.desc = "Diagnostics quickfix";
    }
    {
      mode = "n";
      key = "<leader>wj";
      action = "<cmd>wincmd j<cr>";
      options.desc = "Focus window below";
    }
    {
      mode = "n";
      key = "<leader>wk";
      action = "<cmd>wincmd k<cr>";
      options.desc = "Focus window above";
    }
  ];
}
