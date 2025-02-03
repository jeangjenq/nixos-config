{
  description = "jeangjenq's nix flakes.";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    stylix.url = "github:danth/stylix";
    home-manager.url = "github:nix-community/home-manager"; 
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, nix-darwin, stylix, home-manager, ... }:
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
    
    # pkgs = nixpkgs.legacyPackages.${system};
    pkgs = import nixpkgs {
      system = systemSettings.system;
      config = {
        allowUnfree = true;
      };
    };
    
  in
  {
    nixosConfigurations = {
      system = nixpkgs.lib.nixosSystem {
        system = systemSettings.system;
	modules = [
	  (./. + "/profiles" + ("/" + systemSettings.profile) + "/configuration.nix")
	  stylix.nixosModules.stylix
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
	  stylix.homeManagerModules.stylix
	];
	extraSpecialArgs = {
	  inherit systemSettings;
	  inherit userSettings;
	};
      };
    };

    darwinConfigurations = {
      system = nix-darwin.lib.darwinSystem {
        system = systemSettings.system;
        modules = [
	  (./. + "/profiles" + ("/" + systemSettings.profile) + "/configuration.nix")
	  stylix.darwinModules.stylix
	];
	specialArgs = {
	  inherit systemSettings;
	  inherit userSettings;
	};
      };
    };
  };
}
