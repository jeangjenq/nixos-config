{
  pkgs,
  lib,
  dmenu,
  label ? "Time conversion",
  name ? "mathtime",
  conversions ? [
    # unit: desired conversion
    # formular: conversion, $num as entered number
    # scale: how many decimal to show
    {
      unit = "hours to seconds";
      formular = "$num*60*60";
      scale = "0";
    }
    {
      unit = "minutes to hours";
      formular = "$num/60";
      scale = "2";
    }
  ],
  ...
}:
let
  notify = {
    send = lib.concatStringsSep " " [
      "${pkgs.libnotify}/bin/notify-send"
      "-a quick-math"
      ''-i "${pkgs.papirus-icon-theme}/share/icons/Papirus/16x16/apps/gnome-calculator.svg"''
      "--"
    ];
  };
in
rec {
  inherit name label conversions;
  description = ''
    Unit conversions through dmenu, results are broadcast through notifications.
  '';
  choices = lib.concatLines (
    map (
      {
        unit,
        formular,
        scale,
      }:
      "${unit}"
    ) conversions
  );
  cases = lib.concatLines (
    map (
      {
        unit,
        formular,
        scale,
      }:
      ''
        "${unit}")
            num=$(${dmenu.command} ${dmenu.prompt "Enter number:"})
            # make sure number is valid int or float
            if [[ $num =~ ^\.?[0-9]+(\.[0-9]+)?$ ]]; then
                result=$(echo "scale=${scale}; ${formular}" | ${pkgs.bc}/bin/bc)
                ${notify.send} "$result"
            else
                ${notify.send} "$num is not a number."
                exit 0
            fi
            ;;
      ''
    ) conversions
  );

  package = pkgs.writeShellApplication {
    inherit name;
    runtimeInputs = [
      dmenu.package
      pkgs.bc
      pkgs.libnotify
      pkgs.papirus-icon-theme
    ];
    text = ''
      choice=$(printf "%s" "${choices}" | ${dmenu.command} ${dmenu.prompt "Pick a conversion:"} || exit 0)

      case "$choice" in
          ${cases}
      esac
    '';
  };
}
