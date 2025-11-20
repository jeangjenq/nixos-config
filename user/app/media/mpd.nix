{ ... }:

{
  services = {
    mpd = {
      enable = true;
      musicDirectory = "/mnt/Warp/Music";
      playlistDirectory = "/mnt/Warp/Music/Playlists";
      extraConfig = ''
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
}
