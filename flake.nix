{
  description = "jeangjenq's nix flakes.";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.11";
    stylix.url = "github:danth/stylix";
    home-manager.url = "github:nix-community/home-manager/release-24.11"; 
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, ... }:
  let
    # ---------- VARIABLES ---------- #
    systemSettings = {
      system = "x86_64-linux";
      hostname = "padd";
      profile = "personal";
      wm = "gnome";
      timezone = "Pacific/Auckland";
      locale = "en_US.UTF-8";
    };
    # user variables
    userSettings = {
      username = "jeangjenq";
      email = "jeangjenq@jeangjenq.com";
      dotfilesDir = "~/.dotfiles"; # absolute path to dotfiles
      term = "alacritty";
    };
    # ---------- VARIABLES ---------- #
    
    lib = inputs.nixpkgs.lib;
    # pkgs = nixpkgs.legacyPackages.${system};
    home-manager = inputs.home-manager;
    pkgs = import inputs.nixpkgs {
      system = systemSettings.system;
      config = {
        allowUnfree = true;
      };
    };
    
  in
  {
    nixosConfigurations = {
      system = lib.nixosSystem {
        system = systemSettings.system;
	modules = [
	  (./. + "/profiles" + ("/" + systemSettings.profile) + "/configuration.nix")
	  inputs.stylix.nixosModules.stylix
	];
	specialArgs = {
	  inherit systemSettings;
	  inherit userSettings;
	};
      };
    };

    homeConfigurations = {
      user = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
	modules = [
	  (./. + "/profiles" + ("/" + systemSettings.profile) + "/home.nix")
	  inputs.stylix.homeManagerModules.stylix
	];
	extraSpecialArgs = {
	  inherit systemSettings;
	  inherit userSettings;
	};
      };
    };
  };
}
