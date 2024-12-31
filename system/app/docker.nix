{ pkgs, lib, userSettings, ... }:

{
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    autoPrune.enable = true;
  };

  users.users.${userSettings.username}.extraGroups = [ "docker" ];
  
  environment.systemPackages = [ pkgs.docker ];
}
