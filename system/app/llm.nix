{ pkgs-stable, ... }:

{
  services = {
    ollama = {
      enable = true;
      package = pkgs-stable.ollama-vulkan;
    };

    open-webui = {
      enable = true;
      port = 4173;
      package = pkgs-stable.open-webui;
    };
  };
}
