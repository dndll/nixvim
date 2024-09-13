{pkgs, ...}: let
  prebuiltPlugin = pkgs.callPackage ./plugin.nix {};
in {
  # TODO: only if providers=copilot
  # plugins.copilot-lua = {
  #   enable = true;
  #   panel.enabled = false;
  #   suggestion.enabled = false;
  # };
  plugins.dressing.enable = true;

  extraPlugins = with pkgs.vimUtils;
  with pkgs; [
    #   (let
    #     _name = "avante.nvim";
    #     version = "0.54-unstable-2024-08-13";
    #     src = pkgs.fetchFromGitHub {
    #       owner = "yetone";
    #       repo = "avante.nvim";
    #       rev = "0642905c8017daeb5fd2ca2892aae22a84721c33";
    #       hash = "sha256-Qda2Ky6VOV6tMOcpmt5/G7w5kHhtsqj4NugQZjytjSc=";
    #     };
    #     # TODO: luajit lua51 features
    #     tokenizers = rustPlatform.buildRustPackage {
    #       name = "avante-tokenizers";
    #       inherit src;
    #       cargoBuildFlags = ["--release" "-p" "avante-tokenizers"];
    #       buildFeatures = ["lua54"];
    #       cargoLock = {
    #         lockFile = ./Cargo.lock;
    #         outputHashes = {
    #           "mlua-0.10.0-beta.1" = "sha256-ZEZFATVldwj0pmlmi0s5VT0eABA15qKhgjmganrhGBY=";
    #         };
    #       };
    #       postInstall = ''
    #         ls $out/lib
    #       '';
    #       RUSTC_BOOTSTRAP = 1;
    #       nativeBuildInputs = [
    #         pkg-config
    #       ];
    #
    #       buildInputs =
    #         [
    #           libgit2
    #           zlib
    #           openssl
    #         ]
    #         ++ lib.optionals stdenv.isDarwin [
    #           darwin.apple_sdk.frameworks.AppKit
    #           darwin.apple_sdk.frameworks.CoreServices
    #           darwin.apple_sdk.frameworks.SystemConfiguration
    #         ];
    #     };
    #     templates = rustPlatform.buildRustPackage {
    #       name = "avante-templates";
    #       inherit version src;
    #       cargoBuildFlags = ["--release" "-p" "avante-templates"];
    #       buildFeatures = ["lua54"];
    #       cargoLock = {
    #         lockFile = ./Cargo.lock;
    #         outputHashes = {
    #           "mlua-0.10.0-beta.1" = "sha256-ZEZFATVldwj0pmlmi0s5VT0eABA15qKhgjmganrhGBY=";
    #         };
    #       };
    #       RUSTC_BOOTSTRAP = 1;
    #
    #       nativeBuildInputs = [
    #         pkg-config
    #       ];
    #
    #       buildInputs =
    #         [
    #           libgit2
    #           zlib
    #           openssl
    #         ]
    #         ++ lib.optionals stdenv.isDarwin [
    #           darwin.apple_sdk.frameworks.AppKit
    #           darwin.apple_sdk.frameworks.CoreServices
    #           darwin.apple_sdk.frameworks.SystemConfiguration
    #         ];
    #     };
    # in
    #     buildVimPlugin {
    #       pname = _name;
    #       inherit version src;
    #
    #       nativeBuildInputs = [
    #         cmake
    #         curl
    #         cargo
    #         rustc
    #         # rustPlatform.cargoSetupHook
    #       ];
    #
    #       postInstall = ''
    #         mkdir -p $out/build
    #         ln -s ${tokenizers}/lib/libavante_tokenizers.so $out/build/avante_tokenizers.so
    #         ln -s ${tokenizers}/lib/libavante_tokenizers.so $out/build/libAvanteTokenizers-lua54.so
    #         ln -s ${templates}/lib/libavante_templates.so $out/build/avante_templates.so
    #         ln -s ${templates}/lib/libavante_templates.so $out/build/libAvanteTemplates-lua54.so
    #       '';
    #   })
    {
      plugin = vimPlugins.render-markdown;
      # config = ''
      # require('render-markdown').setup({file_types = { 'markdown', 'vimwiki' },})
      # '';
    }
    vimPlugins.plenary-nvim
    vimPlugins.nui-nvim
    prebuiltPlugin
  ];
  extraConfigLua = ''
    require("avante_lib").load()

    require("avante").setup({
      ---@alias Provider "claude" | "openai" | "azure" | "gemini" | "cohere" | "copilot" | string
      provider = "deepseek", -- Recommend using Claude
      claude = {
        endpoint = "https://api.anthropic.com",
        model = "claude-3-5-sonnet-20240620",
        temperature = 0,
        max_tokens = 4096,
      },
      vendors = {
      ---@type AvanteProvider
        ["deepseek"] = {
          endpoint = "https://api.deepseek.com/beta/chat/completions",
          model = "deepseek-coder",
          api_key_name = "DEEPSEEK_API_KEY",
          max_tokens = 8192,
          parse_curl_args = function(opts, code_opts)
            return {
              url = opts.endpoint,
              headers = {
                ["Accept"] = "application/json",
                ["Content-Type"] = "application/json",
                ["Authorization"] = "Bearer " .. os.getenv(opts.api_key_name),
              },
              body = {
                model = opts.model,
                messages = require("avante.providers").copilot.parse_message(code_opts), -- you can make your own message, but this is very advanced
                temperature = 0,
                max_tokens = 4096,
                stream = true, -- this will be set by default.
              },
            }
          end,
          parse_response_data = function(data_stream, event_state, opts)
            require("avante.providers").copilot.parse_response(data_stream, event_state, opts)
          end,
      },
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
