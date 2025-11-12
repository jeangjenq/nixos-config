{ ... }:

{
  services = {
    mpd = {
      enable = true;
      musicDirectory = "/mnt/Warp/music";
      extraConfig = ''
        auto_update "yes"
        audio_output {
          type "pipewire"
          name "music"
        }
      '';
    };

    mpdris2 = {
      enable = true;
      multimediaKeys = true;
    };
  };

  programs.rmpc = {
    enable = true;
    config = ''
      (
        wrap_navigation: true,
      )
    '';
  };
}
