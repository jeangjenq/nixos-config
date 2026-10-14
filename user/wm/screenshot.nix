{
  pkgs,
  ...
}:
let
  out_dir = "$HOME/Pictures/screenshots";
in
{
  grab = pkgs.writeShellApplication {
    name = "screengrab";
    runtimeInputs = [
      pkgs.grim
      pkgs.slurp
      pkgs.satty
    ];
    text = ''
      mkdir -p "${out_dir}"
      ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" - | ${pkgs.satty}/bin/satty \
        --filename - \
        --output-filename \
        "${out_dir}/satty-$(date '+%Y%m%d-%H:%M:%S').png"
    '';
  };

  shot = pkgs.writeShellApplication {
    name = "screenshot";
    runtimeInputs = [
      pkgs.grim
      pkgs.slurp
      pkgs.satty
    ];
    text = ''
      mkdir -p "${out_dir}"
      ${pkgs.grim}/bin/grim - | ${pkgs.satty}/bin/satty \
        --filename - \
        --fullscreen \
        --output-filename \
        "${out_dir}/satty-$(date '+%Y%m%d-%H:%M:%S').png"
    '';
  };
}
