{ pkgs, dmenu, ... }:
let
  command = "pkiller";
in
{
  name = "Kill process";
  inherit command;
  description = "Provide a list of running procceses and offer to kill selected.";

  package = pkgs.writeShellApplication {
    name = command;
    runtimeInputs = [
      dmenu.package
    ];
    text = ''
      ps -u "$USER" -o pid,comm | ${dmenu.command} ${dmenu.prompt "Kill:"} | awk '{print $1}' | xargs -r kill
    '';
  };
}
