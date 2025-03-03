{ pkgs, systemSettings, ... }:

{
  # home.packages = [
  #   pkgs.obs-studio
  # ];
  
  programs.obs-studio = {
    enable = true;
    plugins = (
      if systemSettings.system == "aarch64-linux" then
        []
      else
        with pkgs.obs-studio-plugins; [
          obs-pipewire-audio-capture
        ]
    );
  };
}