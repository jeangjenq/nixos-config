{ pkg, ... }:

{
  programs.helix = {
    enable = true;
    settings = {
      editor = {
        line-number = "relative";
        cursor-shape = {
          insert = "bar";
        };
      };
    };
  };

  home.sessionVariables = {
    EDITOR = "hx";
  };
}
