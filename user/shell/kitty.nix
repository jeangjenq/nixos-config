{ ... }:

{
  programs.kitty = {
    enable = true;
    shellIntegration = {
      enableBashIntegration = true;
      enableZshIntegration = true;
    };
    settings = {
      enable_audio_bell = false;
    };
  };
}
