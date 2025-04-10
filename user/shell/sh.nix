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
in
{
  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = aliases;
    initExtra = "cbonsai -p";
  };
  
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    shellAliases = aliases;
    initExtra = "cbonsai -p";
  };
  
  home.packages = with pkgs;[
    tmux
    bottom
    bat
    cbonsai
  ];
}

