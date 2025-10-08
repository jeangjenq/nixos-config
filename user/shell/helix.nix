{ pkgs, lib, ... }:

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
        inline-diagnostics = {
          cursor-line = "warning";
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

  programs.ruff = {
    enable = true;
    settings = {
      line-length = 79;
    };
  };

  home.packages = with pkgs; [
    nil
  ];
}
