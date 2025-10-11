{ config, pkgs, pkgs-stable, ... }:

{
  services = {
    ollama = {
      enable = true;
      acceleration = "rocm";
      package = pkgs-stable.ollama;
    };

    open-webui = {
      enable = true;
      port = 4173;
      package = pkgs-stable.open-webui;
    };
  };
}
