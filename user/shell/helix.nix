{ pkgs, lib, ... }:

{
  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      editor = {
        line-number = "relative";
        auto-pairs = false;
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
      override = {
        inherits = "nightfox";
        "ui.background" = { };
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
    nixfmt
  ];

  # Manually write languages.toml to get inline table format for formatter.
  # home-manager's TOML serializer generates [language.formatter] table format
  # instead of the inline format (formatter = { command = "nixfmt" }) shown in
  # Helix documentation.
  xdg.configFile."helix/languages.toml" = {
    text = ''
    [[language]]
    name = "nix"
    auto-format = false
    formatter = { command = "nixfmt" }

    [[language]]
    name = "python"
    formatter = { command = "ruff", args = ["format", "--line-length", "79", "-"] }
    '';
    force = true;
  };

}
