{
  plugins.trouble = {
    enable = true;
    settings = {
      auto_close = true;
    };
  };
  # TODO: Add keybinds to close trouble (q would be nice), rn I need to use :x to close it...
  keymaps = [
    {
      mode = "n";
      key = "<leader>x";
      action = "+diagnostics/quickfix";
    }
    {
      mode = "n";
      key = "<leader>xx";
      action = "<cmd>Trouble diagnostics<cr>";
      options = {
        silent = true;
        desc = "Document Diagnostics (Trouble)";
      };
    }
    {
      mode = "n";
      key = "<leader>xl";
      action = "<cmd>Trouble<cr>";
      options = {
        silent = true;
        desc = "LSP (Trouble)";
      };
    }
    {
      mode = "n";
      key = "<leader>xt";
      action = "<cmd>Trouble todo<cr>";
      options = {
        silent = true;
        desc = "Todo (Trouble)";
      };
    }
    {
      mode = "n";
      key = "<leader>xQ";
      action = "<cmd>TodoQuickFix<cr>";
      options = {
        silent = true;
        desc = "Quickfix List (Trouble)";
      };
    }
  ];
}
