{ pkgs, ... }:

{
  hardware.opengl = {
    enable = true;
  };

  services.xserver.videoDrivers = [ "amdgpu" ];
}

