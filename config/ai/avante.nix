{pkgs, ...}: {
  # TODO: only if providers=copilot
  # plugins.copilot-lua = {
  #   enable = true;
  #   panel.enabled = false;
  #   suggestion.enabled = false;
  # };
  plugins.dressing.enable = true;

  extraPlugins = with pkgs.vimUtils;
  with pkgs; [
    (buildVimPlugin {
      name = "avante.nvim";
      src = pkgs.fetchFromGitHub {
        owner = "yetone";
        repo = "avante.nvim";
        rev = "e55f9f753f2495e30f1af3a174362b39e24fb1d2";
        hash = "sha256-JsmkDX2AZ3Gt9RA1gRhzrfE9XIwVVIf6dGdNlWJMyb4=";
      };
    })
    {
      plugin = vimPlugins.render-markdown;
      # config = ''
      # require('render-markdown').setup({file_types = { 'markdown', 'vimwiki' },})
      # '';
    }
    vimPlugins.plenary-nvim
    vimPlugins.nui-nvim
  ];
  extraConfigLua = ''
    require("avante_lib").load()

    require("avante").setup({
      ---@alias Provider "claude" | "openai" | "azure" | "gemini" | "cohere" | "copilot" | string
      provider = "claude", -- Recommend using Claude
      claude = {
        endpoint = "https://api.anthropic.com",
        model = "claude-3-5-sonnet-20240620",
        temperature = 0,
        max_tokens = 4096,
      },
      behaviour = {
        auto_suggestions = false, -- Experimental stage
        auto_set_highlight_group = true,
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = false,
        support_paste_from_clipboard = false,
      },
      mappings = {
        --- @class AvanteConflictMappings
        diff = {
          ours = "co",
          theirs = "ct",
          all_theirs = "ca",
          both = "cb",
          cursor = "cc",
          next = "]x",
          prev = "[x",
        },
        suggestion = {
          accept = "<M-l>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
        jump = {
          next = "]]",
          prev = "[[",
        },
        submit = {
          normal = "<CR>",
          insert = "<C-s>",
        },
      },
      hints = { enabled = true },
      windows = {
        ---@type "right" | "left" | "top" | "bottom"
        position = "right", -- the position of the sidebar
        wrap = true, -- similar to vim.o.wrap
        width = 30, -- default % based on available width
        sidebar_header = {
          align = "center", -- left, center, right for title
          rounded = true,
        },
      },
      highlights = {
        ---@type AvanteConflictHighlights
        diff = {
          current = "DiffText",
          incoming = "DiffAdd",
        },
      },
      --- @class AvanteConflictUserConfig
      diff = {
        autojump = true,
        ---@type string | fun(): any
        list_opener = "copen",
      },
    })
  '';
}
