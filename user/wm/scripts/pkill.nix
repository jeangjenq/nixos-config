{
  pkgs,
  dmenu,
  name ? "pkiller",
  label ? "Kill process",
  ...
}:

{
  inherit name label;
  description = "Provide a list of running procceses and offer to kill selected.";

  package = pkgs.writeShellApplication {
    inherit name;
    runtimeInputs = [
      dmenu.package
    ];
    text = ''
      ps -u "$USER" -o pid,comm | ${dmenu.command} ${dmenu.prompt "Kill:"} | awk '{print $1}' | xargs -r kill
    '';
  };
}
