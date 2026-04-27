{ ... }:

{
  services.displayManager.ly = {
    enable = true;
    settings = {
      animation = "matrix";
      bigclock = "en";
      big_clock_12hr = true;
      clear_password = true;
      session_log = ".local/state/ly-session.log";
    };
  };
}
