{
  plugins.markdown-preview = {
    enable = true;
    settings = {
      browser = "floorp";
      theme = "dark";
    };
  };
  keymaps = [
    {
      mode = "n";
      key = "<leader>lmp";
      action = "<cmd>MarkdownPreview<cr>";
      options = {
        desc = "Markdown Preview";
      };
    }
  ];
}
