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
        indent-guides = {
          render = true;
          character = "╎";
        };
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

    languages = {
      language = [
        {
          name = "nix";
          auto-format = false;
          formatter = {
            command = "nixfmt";
          };
        }
        {
          name = "python";
          language-servers = [ "pyright" "ruff" ];
          auto-format = true;
          formatter = {
            command = "ruff";
            args = [ "format" "--line-length" "79" "-" ];
          };
        }
        {
          name = "lua";
          auto-format = true;
          formatter = {
            command = "stylua";
            args = [ "-" ];
          };
        }
        {
          name = "css";
          auto-format = true;
          formatter = {
            command = "prettier";
            args = [ "--parser" "css" ];
          };
        }
        {
          name = "json";
          auto-format = true;
          formatter = {
            command = "prettier";
            args = [ "--parser" "json" ];
          };
        }
        {
          name = "yaml";
          auto-format = true;
          formatter = {
            command = "prettier";
            args = [ "--parser" "yaml" ];
          };
        }
        {
          name = "markdown";
          auto-format = false;
          formatter = {
            command = "prettier";
            args = [ "--parser" "markdown" ];
          };
        }
      ];
    };
  };

  programs.ruff = {
    enable = true;
    settings = {
      line-length = 79;
    };
  };

  programs.stylua = {
    enable = true;
    settings = {
      indent_type = "Spaces";
    };
  };

  home.packages = with pkgs; [
    nil
    nixfmt
    pyright
    marksman
    lua-language-server
    yaml-language-server
    ansible-language-server
    vscode-langservers-extracted
    prettier
  ];
}
