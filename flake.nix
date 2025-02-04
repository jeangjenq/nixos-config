{
  description = "jeangjenq's nix flakes.";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.11";
    stylix.url = "github:danth/stylix/release-24.11";
    home-manager.url = "github:nix-community/home-manager/release-24.11"; 
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-24.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs = inputs@{ self, nixpkgs, stylix, home-manager, nix-darwin, nix-homebrew, ... }:
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

    # homeConfigurations =  if (systemSettings.system == "aarch64-darwin")
    #                       then {}
    #                       else {
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
          # home-manager.darwinModules.home-manager {
          #   home-manager = {
          #     useGlobalPkgs = true;
          #     useUserPackages = true;
          #     users."${userSettings.username}" = import ./profiles/darwin/home.nix;
          #     extraSpecialArgs = {
          #       inherit systemSettings;
          #       inherit userSettings;
          #     };
          #   };
          # }
          stylix.darwinModules.stylix
          nix-homebrew.darwinModules.nix-homebrew {
            nix-homebrew = {
              enable = true;
              # Apple Silicon
              enableRosetta = true;
              user = userSettings.username;
            };
          }
        ];
        specialArgs = {
          inherit systemSettings;
          inherit userSettings;
        };
      };
    };
  };
}
