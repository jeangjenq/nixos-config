{
  pkgs,
  lib,
  dmenu,
  ...
}:

import ./math-module.nix {
  inherit pkgs lib dmenu;
  name = "mathunits";
  label = "Units conversion";
  conversions = [
    {
      unit = "inch to cm";
      formular = "$num * 2.54";
      scale = "2";
    }
    {
      unit = "mile to km";
      formular = "$num * 1.609";
      scale = "2";
    }
    {
      unit = "pound to kg";
      formular = "$num * 0.4536";
      scale = "2";
    }
    {
      unit = "US gallon to litre";
      formular = "$num * 3.78541";
      scale = "0";
    }
    {
      unit = "acre to square meter";
      formular = "$num * 4047";
      scale = "0";
    }
    {
      unit = "fahrenheit to celcius";
      formular = "($num - 32) * 5/9";
      scale = "2";
    }
    {
      unit = "celcius to fahrenheit";
      formular = "($num / 5*9) + 32";
      scale = "2";
    }
  ];
}
