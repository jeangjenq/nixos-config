{ pkgs, ... }:

let
  aliases = {
    ll = "ls -lah";
    htop = "btm";
    cat = "bat";
  };
in
{
  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = aliases; 
  };
  
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    shellAliases = aliases; 
  };
  
  home.packages = with pkgs;[
    bottom
    bat
  ];
}

