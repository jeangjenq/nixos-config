{ pkgs, ... }:

{
  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = {
      ll = "ls -lah";
      htop = "btm";
    };
  };
  
  home.packages = with pkgs;[
    bottom
  ];
}

