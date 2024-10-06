{
  lib,
  pkgs,
  ...
}: {
  plugins.codeium-nvim = {
    enable = true;
    settings = {
      enable_chat = true;
      tools = {
        curl = lib.getExe pkgs.curl;
        gzip = lib.getExe pkgs.gzip;
        uname = lib.getExe' pkgs.coreutils "uname";
        uuidgen = lib.getExe' pkgs.util-linux "uuidgen";
      };
      bin_path.__raw = "vim.fn.stdpath('cache') .. '/codeium/bin'";
      config_path.__raw = "vim.fn.stdpath('cache') .. '/codeium/config.json'";
      # language_server_download_url = "https://github.com";
      api = {
        host = "server.codeium.com";
        port = "443";
      };
      enable_local_search = true;
      enable_index_service = true;
      #search_max_workspace_file_count = 5000;
    };
  };
  plugins.cmp = {
    #settings.sources = [{name = "codeium";}];
  };
}
