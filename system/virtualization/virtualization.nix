{ config, pkgs, userSettings, ... }:

{
  environment.systemPackages = with pkgs; [
    virt-manager
    distrobox
  ];

  virtualisation.libvirtd = {
    enable = true;
  };

  users.users.${userSettings.username}.extraGroups = [ "libvirtd" ];
}
