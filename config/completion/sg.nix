{pkgs, ...}: {
  extraPlugins = with pkgs; [
    vimPlugins.sg-nvim
    vimPlugins.plenary-nvim
  ];
  extraConfigLua = ''
    require("sg").setup({
      chat = {
        default_model = "anthropic/claude-3-5-sonnet-20240620"
      },
    })
  '';
}
