{ pkg, lib, ... }:

{
  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      editor = {
        line-number = "relative";
        cursor-shape = {
          insert = "bar";
        };
        # indent-guides = {
        #   render = true;
        # };
        whitespace = {
          render = {
            space = "all";
            tab = "all";
          };
        };
      };
      theme = lib.mkForce "override";
    };

    themes = {
      override = let
        theme = "flexoki_dark";
        transparent = { };
      in {
        inherits = theme;
        "ui.background" = transparent;
      };
    };
  };
}
