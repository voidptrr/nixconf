{lib, ...}: {
  plugins.lualine = {
    enable = true;
    settings = {
      options = {
        theme = "everforest";
        icons_enabled = false;
        section_separators = "";
        component_separators = "";
      };
      sections = {
        lualine_a = [
          (lib.nixvim.mkRaw ''{ "mode", fmt = function (s) return s:sub(1, 1) end }'')
        ];
        lualine_c = [
          (lib.nixvim.mkRaw ''{ "filename", path = 1 }'')
        ];
      };
    };
  };
}
