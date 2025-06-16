{
  description = "jeangjenq's nix flakes.";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    stylix.url = "github:danth/stylix";
    home-manager.url = "github:nix-community/home-manager"; 
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    nixos-apple-silicon.url = "github:tpwrules/nixos-apple-silicon";
    nixos-apple-silicon.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, stylix, home-manager, nix-darwin, nix-homebrew, ... }:
  let
    # ---------- VARIABLES ---------- #
    systemSettings = {
      system = "x86_64-linux";
      hostname = "worf";
      profile = "default";
      wm = "hyprland";
      timezone = "Pacific/Auckland";
      locale = "en_US.UTF-8";
    };
    # user variables
    userSettings = {
      username = "jeangjenq";
      email = "jeangjenq@jeangjenq.com";
      dotfilesDir = "~/.dotfiles"; # absolute path to dotfiles
      term = "kitty";
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
          inherit inputs;
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
          stylix.homeModules.stylix
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
          home-manager.darwinModules.home-manager {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users."${userSettings.username}" = import ./profiles/darwin/home.nix;
              extraSpecialArgs = {
                inherit systemSettings;
                inherit userSettings;
              };
            };
          }
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
