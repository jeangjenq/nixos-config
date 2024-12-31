{
  description = "jeangjenq's nix flakes.";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.11";
    home-manager.url = "github:nix-community/home-manager/release-24.11"; 
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }:
  let
    # ---------- VARIABLES ---------- #
    systemSettings = {
      system = "x86_64-linux";
      hostname = "nixvm";
      profile = "work";
      timezone = "Pacific/Auckland";
    };
    # user variables
    userSettings = {
      username = "jeangjenq";
      email = "jeangjenq@jeangjenq.com";
      dotfilesDir = "~/.dotfiles"; # absolute path to dotfiles
      term = "alacritty";
    };
    # ---------- VARIABLES ---------- #
    
    lib = nixpkgs.lib;
    # pkgs = nixpkgs.legacyPackages.${system};
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
	];
	extraSpecialArgs = {
	  inherit systemSettings;
	  inherit userSettings;
	};
      };
    };
  };
}
