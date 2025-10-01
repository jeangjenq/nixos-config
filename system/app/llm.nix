{ config, pkgs, ... }:

{
  services = {
    ollama = {
      enable = true;
      acceleration = "rocm";
    };

    open-webui = {
      enable = true;
      port = 4173;
    };
  };
}
