{ pkgs, ... }:

{
  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = {
      ll = "ls -lah";
      htop = "btm";
      cat = "bat";
    };
  };
  
  home.packages = with pkgs;[
    bottom
    bat
  ];
}

