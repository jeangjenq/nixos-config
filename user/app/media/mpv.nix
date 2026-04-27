{ pkgs, ... }:

{
  programs.mpv = {
    enable = true;
    scripts = with pkgs; [
      mpvScripts.mpris
    ];
    config = {
      loop-file = "inf";
      hwdec="auto";
    };
  };
}
