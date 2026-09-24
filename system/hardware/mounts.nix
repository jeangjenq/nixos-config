{ lib, ... }:
let
  inherit (lib) listToAttrs concatLists;
  hosts = [
    # {
    #   host = "";
    #   fsType = "";
    #   export = "";
    #   shares = [
    #   ];
    #   options = [
    #     "x-systemd.automount"
    #     "noauto"
    #     "nofail"
    #   ];
    # }
  ];

  mounts = listToAttrs (
    concatLists (
      map (
        {
          host,
          fsType,
          export,
          shares,
          options,
        }:
        map (name: {
          name = "/mnt/${name}";
          value = {
            device = "${host}:${export}/${name}";
            inherit fsType;
            inherit options;
          };
        }) shares
      ) hosts
    )
  );
in
{
  fileSystems = mounts;
}
