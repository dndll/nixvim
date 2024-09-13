{
  pkgs,
  lib,
  ...
}: let
  mkLsp = import ./path/to/mkLsp.nix; # Adjust this path as needed
  pkg = import ./solidity-language-server-pkg.nix;
in
  mkLsp {
    name = "solidity";
    description = "Enable Solidity Language Server.";
    serverName = "solidity-language-server";
    package = pkg;
    url = "https://github.com/NomicFoundation/hardhat-vscode/tree/development/server";
    cmd = cfg: ["nomicfoundation-solidity-language-server" "--stdio"];
    settings = cfg: cfg;
    extraOptions = {
      installNode = lib.mkOption {
        type = lib.types.nullOr lib.types.bool;
        default = null;
        example = true;
        description = "Whether to install Node.js, which is required for the Solidity Language Server.";
      };

      nodePackage = lib.mkPackageOption pkgs "nodejs" {};
    };
    extraConfig = cfg: {
      config = lib.mkIf cfg.enable {
        warnings = lib.optional (cfg.installNode == null) ''
          The Solidity Language Server relies on Node.js.
          - Set `plugins.lsp.servers.solidity.installNode = true` to install it automatically
            with nixvim. You can customize which package to install by changing
            `plugins.lsp.servers.solidity.nodePackage`.
          - Set `plugins.lsp.servers.solidity.installNode = false` to not have it install
            through nixvim. By doing so, you will dismiss this warning.
        '';

        extraPackages = with pkgs; (lib.optional ((builtins.isBool cfg.installNode) && cfg.installNode) cfg.nodePackage);
      };
    };
  }
