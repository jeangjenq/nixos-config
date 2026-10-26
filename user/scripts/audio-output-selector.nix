{
  pkgs,
  dmenu,
  ...
}:
rec {
  name = "audio-output-selector";
  label = "Change Audio Output";
  description = ''
    Utilize `wpctl` to change pipewire audio output.
  '';

  package = pkgs.writeShellApplication {
    inherit name;
    runtimeInputs = [
      dmenu.package
      pkgs.wireplumber
    ];
    text = ''
      choice=$(
          wpctl status |
          sed -n "/Sinks:/,/Sources:/p" |
          grep -E '[0-9]+\.' |
          sed -E 's/^[^0-9]*([0-9]+)\. (.*)$/\1\t\2/' |
          ${dmenu.command} ${dmenu.prompt "Change audio output:"})

      if [[ -n "$choice" ]]; then
          sink="''${choice%%$'\t'*}"
          wpctl set-default "$sink"
      else
          exit 0
      fi
    '';
  };
}
