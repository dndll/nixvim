{pkgs, ...}: {
  extraPlugins = with pkgs; [
    vimPlugins.sg-nvim
    vimPlugins.plenary-nvim
  ];
  extraConfigLua = ''
    require("sg").setup({})
  '';
}
