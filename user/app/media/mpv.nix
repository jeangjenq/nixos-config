{ pkgs, ... }:

{
  programs.mpv = {
    enable = true;
    scripts = with pkgs; [
      mpvScripts.mpris
    ];
    config = {
      loop-file = "inf";
      hwdec = "auto";
      target-colorspace-hint-mode = "source";
    };
  };
}
