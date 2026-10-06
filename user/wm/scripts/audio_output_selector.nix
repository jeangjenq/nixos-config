{
  pkgs,
  dmenu,
  ...
}:
let
  command = "audio-output-selector";
in
{
  name = "Change Audio Output";
  inherit command;
  description = ''
    Utilize `wpctl` to change pipewire audio output.
  '';

  package = pkgs.writeShellApplication {
    name = command;
    runtimeInputs = [
      pkgs.wireplumber
    ];
    text = ''
      choice=$(
          ${pkgs.wireplumber}/bin/wpctl status |
          sed -n "/Sinks:/,/Sources:/p" |
          grep -E '[0-9]+\.' |
          sed -E 's/^[^0-9]*([0-9]+)\. (.*)$/\1\t\2/' |
          ${dmenu.command} -p "Change audio output:")

      if [[ -n "$choice" ]]; then
          sink="''${choice%%$'\t'*}"
          ${pkgs.wireplumber}/bin/wpctl set-default "$sink"
      else
          exit 0
      fi
    '';
  };
}
