{
  plugins.rustaceanvim = {
    enable = true;
    settings = {
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
}
