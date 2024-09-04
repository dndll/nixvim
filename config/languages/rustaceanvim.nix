{
  plugins.crates-nvim.enable = true;
  plugins.rustaceanvim = {
    enable = true;
    settings = {
      tools = {
        float_win_config = {
          auto_focus = true;
          open_split = "vertical";
        };
      };
      server = {
        default_settings."rust-analyzer" = {
          rust-analyzer = {
            checkOnSave = true;
            check = {
              command = "clippy";
            };
            inlayHints = {
              enable = true;
              showParameterNames = true;
              parameterHintsPrefix = "<- ";
              otherHintsPrefix = "=> ";
            };
            procMacro = {
              enable = true;
            };
          };
          cargo = {
            extraEnv = {CARGO_PROFILE_RUST_ANALYZER_INHERITS = "dev";};
            extraArgs = ["--profile" "rust-analyzer"];
          };
        };
      };
    };
  };
  keymaps = [
    {
      mode = ["n" "v"];
      key = "<leader>r";
      action = "+rustaceanvim";
      options = {
        silent = true;
        desc = "Rustaceanvim";
      };
    }
    {
      mode = ["n"];
      key = "<leader>rj";
      action = "<cmd>:RustLsp joinLines<cr>";
      options = {
        silent = true;
        desc = "Join Lines";
      };
    }

    {
      mode = ["n"];
      key = "<leader>rr";
      action = "<cmd>:RustLsp { 'ssr', '<query>' --[[ optional ]] }<cr>";
      options = {
        silent = true;
        desc = "Structural Search and Replace";
      };
    }

    {
      mode = ["n"];
      key = "gp";
      action = "<cmd>:RustLsp parentModule<cr>";
      options = {
        silent = true;
        desc = "Goto Parent Module";
      };
    }

    {
      mode = ["n"];
      key = "gm";
      action = "<cmd>:RustLsp openCargo<cr>";
      options = {
        silent = true;
        desc = "Goto Cargo Manifest";
      };
    }

    {
      mode = ["n"];
      key = "<leader>re";
      action = "<cmd>:RustLsp explainError<cr>";
      options = {
        silent = true;
        desc = "Explain Error";
      };
    }

    {
      mode = ["n"];
      key = "<leader>rt";
      action = "<cmd>:RustLsp testables<cr>";
      options = {
        silent = true;
        desc = "Explore Tests";
      };
    }
    {
      mode = ["n"];
      key = "<leader>rT";
      action = "<cmd>:RustLsp! testables<cr>";
      options = {
        silent = true;
        desc = "Rerun last test";
      };
    }

    {
      mode = ["n"];
      key = "<leader>rl";
      action = "<cmd>:RustLsp runnables<cr>";
      options = {
        silent = true;
        desc = "Explore Runnables";
      };
    }
    {
      mode = ["n"];
      key = "<leader>rL";
      action = "<cmd>:RustLsp runnables<cr>";
      options = {
        silent = true;
        desc = "Explore Runnables";
      };
    }

    {
      mode = ["n"];
      key = "<leader>rc";
      action = "<cmd>:RustLsp flyCheck<cr>";
      options = {
        silent = true;
        desc = "FlyCheck";
      };
    }

    {
      key = "s";
      action.__raw = ''
        function()
          require'hop'.hint_words()
        end
      '';
      options.remap = true;
    }
    {
      key = "<S-s>";
      action.__raw = ''
        function()
          require'hop'.hint_lines()
        end
      '';
      options.remap = true;
    }
    {
      key = "t";
      action.__raw = ''
        function()
          require'hop'.hint_char1({
            direction = require'hop.hint'.HintDirection.AFTER_CURSOR,
            current_line_only = true,
            hint_offset = -1
          })
        end
      '';
      options.remap = true;
    }
    {
      key = "T";
      action.__raw = ''
        function()
          require'hop'.hint_char1({
            direction = require'hop.hint'.HintDirection.BEFORE_CURSOR,
            current_line_only = true,
            hint_offset = 1
          })
        end
      '';
      options.remap = true;
    }
  ];
}
