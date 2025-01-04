# jeangjenq's NixOS config
I decided to learn NixOS, seems fun.
I'm setting this up based on [LibrePhoenix's extensive tutorial](https://www.youtube.com/playlist?list=PL_WcXIXdDWWpuypAEKzZF2b5PijTluxRG) (Thanks LibrePhoenix!).

## Install on a new system.
TODO: Make an install script
1. Clone this repository into home folder. I prefer to place it inside `.dotfiles` folder.
1. cd into the repository.
1. Replace the `hardware-configuration.nix` in system folder by running
   ```bash
   sudo nixos-generate-config --show-hardware-config > system/hardware-configuration.nix
   ```
   - Although it warns you not to do it inside `hardware-configuration.nix`, I can edit the `fileSystems` section in it at this stage to configure mounting any network shares.
1. Change `hostname` in (flakes.nix)[./flakes.nix].
1. Change boot mode in (configuration.nix)[./profiles/work/configuration.nix] if necessary, use `/etc/nixos/configuration.nix` as a reference.
1. Enable flakes in `/etc/nixos/configuration.nix` by adding the line
   ```yaml
   nix.settings.experimental-features = [ "nix-command" "flakes" ];
   ```
   Then run `sudo nixos-rebuild test`
1. Now that NixOS has flakes, switch to the cloned flakes.
   ```bash
   sudo nixos-rebuild switch --flake ~/.dotfiles#system
   ```
1. If the rebuild went well, install and build home-manager configuration.
   ```bash
   nix run home-manager/master --extra-experimental-features nix-command --extra-experimental-features flakes -- switch --flake ~/.dotfiles#user
   ```
