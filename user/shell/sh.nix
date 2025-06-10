{ pkgs, ... }:

let
  aliases = {
    ll = "ls -lah";
    htop = "btm";
    cat = "bat";
    # human readable is always nice
    df = "df -h";
    du = "du --max-depth=1 -h";
  };
  extra = ''
    cbonsai -p
    if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
      tmux attach-session -t default || tmux new-session -s default
    fi
  '';
in
{
  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = aliases;
    initExtra = extra;
  };
  
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    shellAliases = aliases;
    initContent = extra;
  };
  
  home.packages = with pkgs;[
    tmux
    bottom
    bat
    cbonsai
  ];
}

