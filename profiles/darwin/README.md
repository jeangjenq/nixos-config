# M1 Macbook Air config
This is my first ARM device and there are many caveats especially runnning macOS.

## Firefox
My browser of choice Firefox is [not supported](https://discourse.nixos.org/t/firefox-unsupported-on-aarch64-darwin/18388) on nix-darwin, and htus unsupported via home-manager. There are several ways to get it installed. 

### Homebrew
[zhaofengli/nix-homebrew](https://github.com/zhaofengli/nix-homebrew) lets you declaritively install homebrew packages. If you try to manage its settings with home-manager, you'll have to set home-manager's package to null.
```nix
programs.firefox.package = null;
```

### Overlays
[bandithedoge/nixpkgs-firefox-darwin](https://github.com/bandithedoge/nixpkgs-firefox-darwin) allows home-manger's `program.firefox.enable` to work somewhat properly by overriding the firefox package used with firefox-bin.
```nix
programs.firefox.package = pkgs.firefox-bin;
```
