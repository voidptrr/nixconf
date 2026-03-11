{pkgs, ...}: {
  extraPackages = with pkgs; [ripgrep];

  viAlias = true;
  vimAlias = true;

  globals = {
    mapleader = ",";
    maplocalleader = ",";
    c_syntax_for_h = 1;
  };

  diagnostic.settings = {
    virtual_lines = false;
    virtual_text = false;
    signs = true;
    underline = true;
    update_in_insert = false;
    severity_sort = true;
  };

  opts = {
    background = "dark";
    termguicolors = true;
    number = true;
    cursorline = true;
    numberwidth = 1;
    signcolumn = "yes";

    splitbelow = true;
    splitright = true;
    equalalways = true;

    shiftwidth = 4;
    tabstop = 4;
    softtabstop = 4;
    expandtab = true;
    smarttab = true;
    autoindent = true;
    smartindent = true;

    smartcase = true;
    ignorecase = true;
    hlsearch = true;
    incsearch = true;

    swapfile = false;
    wrap = true;
    linebreak = true;
    inccommand = "split";
    title = true;
    titlestring = "%t%( %M%)%( (%{expand(\"%:~:h\")})%)%a (nvim)";

    laststatus = 2;
    showcmd = true;
    showmode = false;
    cmdheight = 0;

    clipboard = "unnamedplus";
    encoding = "utf-8";
  };

  files = {
    "ftplugin/nix.lua" = {
      opts = {
        shiftwidth = 2;
        tabstop = 2;
        softtabstop = 2;
      };
    };
  };
}
