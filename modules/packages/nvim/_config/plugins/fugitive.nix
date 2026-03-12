{
  plugins.fugitive.enable = true;

  keymaps = [
    {
      mode = "n";
      key = "<leader>gs";
      action = "<cmd>Git<cr>";
      options.desc = "Git status";
    }
    {
      mode = "n";
      key = "<leader>gm";
      action = "<cmd>Git commit<cr>";
      options.desc = "Git commit";
    }
    {
      mode = "n";
      key = "<leader>gp";
      action = "<cmd>Git push<cr>";
      options.desc = "Git push";
    }
    {
      mode = "n";
      key = "<leader>gP";
      action = "<cmd>Git pull<cr>";
      options.desc = "Git pull";
    }
  ];
}
