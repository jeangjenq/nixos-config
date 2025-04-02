{ pkgs, userSettings }:

{
  networking.firewall.allowedTCPPorts = [ 8384 22000 ];
  networking.firewall.allowedUDPPorts = [ 22000 21027 ];
  
  services = {
    syncthing = {
      enable = true;
      grou = "users";
      user = userSettings.username;
      dataDir = home.homeDirectory;
      configDir = home.homeDirectory + "/" + ".config/syncthing";
      
      settings = {
        devices = {
          "Itzal" = { id = "K2LDOFZ-H65MZHS-ECLQGJK-PDL722F-5DY3EIS-FBRQZ6Z-SGMKVIF-OH3ZLQ7"; };
        };

        folders = {
          "cura" = {
            path = home.homeDirectory + "/" + ".local/share/cura"
          };
        }
      };
    };
  };
}