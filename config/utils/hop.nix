{
  plugins.hop = {
    enable = true;
    settings = {
      keys = "fjdkslaghqwerioputy";
    };
  };
  keymaps = [
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
