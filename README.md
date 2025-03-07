# jeangjenq's NixOS config
This is my Nix(OS) config at home. I have several profiles depending on what machine I'm on.

## Profiles
### default
This is my most comprehensive profile that's meant for home PC or x86_64 laptops. Notable configs in this profile that may be missing from other profiles:
 - docker
 - distrobox
 - virtualization with virt-manager
 - davinci-resolve
 - gaming software/hardware configs
   - steam
   - heroic
   - 8bitdo config


### asahi
M1 Macbook Air running NixOS.

### darwin
nix only config for M1 Macbook Air on MacOS. The only profile in here that has home-manager as a module.

### Install on a new system.
TODO: Make an install script
1. Clone this repository into home folder. I prefer to place it inside `.dotfiles` folder.
1. cd into the repository.
1. Adjust `hostname`, `system` and `profile` in [flakes.nix](./flakes.nix).

### NixOS
1. Replace the `hardware-configuration.nix` in system folder by running
   ```bash
   sudo nixos-generate-config --show-hardware-config > system/hardware-configuration.nix
   ```
   Although `hardware-configuration.nix` itself caution against editing it, I tend to edit the `fileSystems` section in it at this stage to configure mounting any network shares.
1. Change boot mode in (configuration.nix)[./profiles/work/configuration.nix] if necessary, using `/etc/nixos/configuration.nix` as a reference.
1. Rebuild with flake.
   ```bash
   sudo nixos-rebuild switch --flake ~/.dotfiles#system
   ```
1. If the rebuild went well, install and build home-manager configuration.
   ```bash
   nix run home-manager/master --extra-experimental-features nix-command --extra-experimental-features flakes -- switch --flake ~/.dotfiles#user
   ```

### MacOS
1. First we must install MacOS's command line tools by executing
   ```bash
   xcode-select --install
   ```
1. [Install nix package manager](https://nixos.org/download/) and follow its instructions.
1. Run the following command to apply system configurations.
   ```bash
   nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake ~/.dotfiles#system
   ```
1. darwin profile installs `firefox` via `nix-homebrew`. But I never couldn't get `home-manager` to deploy my desired firefox policies. So in darwin profile I place the firefox's `policies.json` in `/etc` and manually link it to where it should go with this command.
```bash
sudo ln -s /etc/firefox/policies.json /Applications/Firefox.app/Contents/Resources/distribution/policies.json
```


## Rebuilding
Rebuild process is different on different OS.
### NixOS
I don't include `home-manager` as a module in `nixosConfigurations`, so I can pick and choose when I rebuild system and user level stuff.
#### system
```bash
sudo nixos-rebuild switch --flake ~/.dotfiles#system
```
#### user
```bash
home-manager switch --flake ~/.dotfiles#user
```

### MacOS
Since rebuilding won't generate new GRUB entry on MacOS, I simply include `home-manager` as a module and each rebuild triggers both.
```bash
darwin-rebuild switch --flake ~/.dotfiles#system
```
However, when I make user level only changes, rebuilding via `home-manager` only is also an option.
```bash
home-manager switch --flake ~/.dotfiles#user
```