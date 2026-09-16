{ pkgs, ... }:

let
  aliases = {
    ll = "ls -lh";
    htop = "btop";
    cat = "bat";
    # human readable is always nice
    df = "df -h";
    du = "du -d 1 -h";
    weather = "curl wttr.in/akl";
  };
  extra = ''
    if [ -z "$TMUX" ]; then
      tmux new -As default
    fi
  '';
in
{
  imports = [
    ./starship.nix
  ];

  programs = {
    bash = {
      enable = true;
      enableCompletion = true;
      shellAliases = aliases;
      initExtra = extra;
    };
    zsh = {
      enable = true;
      enableCompletion = true;
      shellAliases = aliases;
      initContent = extra;

      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      history = {
        ignoreDups = true;
        ignoreAllDups = true;
        saveNoDups = true;
        ignoreSpace = true;
        ignorePatterns = [
          "rm *"
          "git *"
          "mpv *"
          "echo *"
          "print *"
        ];
      };
    };

    tmux = {
      enable = true;
      mouse = true;
      keyMode = "vi";
      escapeTime = 5;
      terminal = "screen-256color";
    };

    fzf = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      tmux.enableShellIntegration = true;
    };

    bat.enable = true;
    btop.enable = true;
  };
}
