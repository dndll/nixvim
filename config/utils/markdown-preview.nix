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
      key = "<leader>lm";
      action = "<cmd>+markdown";
      options = {
        desc = "Markdown";
      };
    }
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
