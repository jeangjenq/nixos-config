{ pkgs, lib, ... }:
let
  wallpapers = [
    {
      name = "momo.png";
      url = "https://w.wallhaven.cc/full/d8/wallhaven-d8gjeg.png";
      hash = "sha256-IsmiqjIfbpczUYYJb/BvwWCZjY6xIjHjR1HgtdSiA+A=";
    }
    {
      name = "a2.png";
      url = "https://w.wallhaven.cc/full/gp/wallhaven-gpl16e.png";
      hash = "sha256-Mh65wlIh9+lj323DL6l27dsFwLiCgnkXu8XRw7FuwJI=";
    }
    {
      name = "kcd2_gold_keyart.jpg";
      url = "https://www.deepsilver.com/media/mwbjh3r3/kcd2_wallpaper-gold-keyart_desktop_3840x2160.jpg";
      hash = "sha256-RTXWnE3FWyYLJ+/PKB+M/26pXy9rtVZR68EeWGBVNQA=";
    }
    {
      name = "kcd2_sheperd.jpg";
      url = "https://www.deepsilver.com/media/akobvqnn/kcd2-shepherd-wallpaper-fullhd.jpg";
      hash = "sha256-WZ3AGaB/gQF2ts8cT7KsTDcR0OkQmolRxrfYnzPnsrU=";
    }
    {
      name = "kcd2_brushes_with_death.jpg";
      url = "https://www.deepsilver.com/media/vk0bxl5j/kcd2_wallpaper_brushes-with-death_desktop_3840x2160.jpg";
      hash = "sha256-wkmJsU6at5wze6xY/6HtpGdqmZQ+vG5nQEJuyG/NLcI=";
    }
    {
      name = "shoulder_touch.png";
      url = "https://w.wallhaven.cc/full/gp/wallhaven-gp9keq.png";
      hash = "sha256-EDhfHTFOUTdoAIqykw7ED0gElFeaW2uuFF0+kdhB5Rk=";
    }
    {
      name = "shapoco_bombing_test.jpg";
      url = "https://w.wallhaven.cc/full/vp/wallhaven-vp299m.jpg";
      hash = "sha256-xVPf2xN0ni5/COTE7BhaN0Po0bQvsMq+iGgLGDKnP4M=";
    }
    {
      name = "sts_41-b.jpg";
      url = "https://images-assets.nasa.gov/image/S84-27031/S84-27031~orig.jpg";
      hash = "sha256-SlUbnI3wqMFnq5fhcA8rLY1BT+PO4AaUlL7E7rUAHkg=";
    }
    {
      name = "landers_peak.jpg";
      url = "https://www.arthistoryproject.com/site/assets/files/18387/albert-bierstadt-the-rocky-mountains-lander-1039-s-peak-1863-trivium-art-history.jpg";
      hash = "sha256-GjJlDQ/wbIFHO+QcTM/3rNI2/xD/JPteXfnBfKHFNuY=";
    }
    {
      name = "a_storm_in_the_rocky_mountains.jpg";
      url = "https://www.arthistoryproject.com/site/assets/files/21882/albert_bierstadt-a_storm_in_the_rocky_mountains-_mt._rosalie-1866-trivium-art-history.jpg";
      hash = "sha256-SVz2Ee1gyU/GzDEHJf6qkB6AEOlADUipnOwdZU4cQSQ=";
    }
  ];
  inherit (lib) listToAttrs;
in
{
  home.file = listToAttrs (
    map (
      {
        name,
        url,
        hash,
      }:
      {
        name = "Pictures/wallpapers/${name}";
        value.source = pkgs.fetchurl {
          inherit url hash;
        };
      }
    ) wallpapers
  );
}
