{ config, pkgs, userSettings, ... }:

{
  environment.systemPackages = with pkgs; [
    virt-manager
    docker
    distrobox
  ];

  virtualisation = {
    libvirtd = {
      enable = true;
    };
    docker = {
      enable = true;
      enableOnBoot = true;
      # autoPrune.enable = true;
    };
  };

  users.users.${userSettings.username}.extraGroups = [
    "libvirtd"
    "docker"
  ];
}
