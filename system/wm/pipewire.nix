{ pkgs-stable, ... }:

{
  # Pipewire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    package = pkgs-stable.pipewire;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
}
