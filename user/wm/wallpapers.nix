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
      name = "Kingdom Come Deliverance 2.jpg";
      url = "https://www.deepsilver.com/media/mwbjh3r3/kcd2_wallpaper-gold-keyart_desktop_3840x2160.jpg";
      hash = "sha256-RTXWnE3FWyYLJ+/PKB+M/26pXy9rtVZR68EeWGBVNQA=";
    }
    {
      name = "Sheperd.jpg";
      url = "https://w.wallhaven.cc/full/yx/wallhaven-yxy3ld.png";
      hash = "sha256-jzqAApeLJZC+MLxgSOxuBVkeI89JwmLrKDjlpZ6ExgM=";
    }
    {
      name = "Brushes with Death.jpg";
      url = "https://www.deepsilver.com/media/vk0bxl5j/kcd2_wallpaper_brushes-with-death_desktop_3840x2160.jpg";
      hash = "sha256-wkmJsU6at5wze6xY/6HtpGdqmZQ+vG5nQEJuyG/NLcI=";
    }
    {
      name = "Shoulder Touch.png";
      url = "https://w.wallhaven.cc/full/gp/wallhaven-gp9keq.png";
      hash = "sha256-EDhfHTFOUTdoAIqykw7ED0gElFeaW2uuFF0+kdhB5Rk=";
    }
    {
      name = "Bombing Test.jpg";
      url = "https://w.wallhaven.cc/full/vp/wallhaven-vp299m.jpg";
      hash = "sha256-xVPf2xN0ni5/COTE7BhaN0Po0bQvsMq+iGgLGDKnP4M=";
    }
    {
      name = "STS-41B.jpg";
      url = "https://images-assets.nasa.gov/image/S84-27031/S84-27031~orig.jpg";
      hash = "sha256-SlUbnI3wqMFnq5fhcA8rLY1BT+PO4AaUlL7E7rUAHkg=";
    }
    {
      name = "Lander's Peak.jpg";
      url = "https://www.arthistoryproject.com/site/assets/files/18387/albert-bierstadt-the-rocky-mountains-lander-1039-s-peak-1863-trivium-art-history.jpg";
      hash = "sha256-GjJlDQ/wbIFHO+QcTM/3rNI2/xD/JPteXfnBfKHFNuY=";
    }
    {
      name = "A Storm in The Rocky Mountains.jpg";
      url = "https://www.arthistoryproject.com/site/assets/files/21882/albert_bierstadt-a_storm_in_the_rocky_mountains-_mt._rosalie-1866-trivium-art-history.jpg";
      hash = "sha256-SVz2Ee1gyU/GzDEHJf6qkB6AEOlADUipnOwdZU4cQSQ=";
    }
    {
      name = "A New View of the Moon.jpg";
      url = "https://images-assets.nasa.gov/image/art002e009287/art002e009287~orig.jpg";
      hash = "sha256-YCgIh6JPLp4pEzdZ9hlWIIYtQrjznf07gMGOFq0ey9U=";
    }
    {
      name = "Eyes on Earth.jpg";
      url = "https://images-assets.nasa.gov/image/art002e009166/art002e009166~orig.jpg";
      hash = "sha256-W64sC7wd/Q9VHsH1045QzSM9XXszZH4WZQhwtg+TRFI=";
    }
    {
      name = "Earthset Views";
      url = "https://images-assets.nasa.gov/image/art002e021007/art002e021007~orig.jpg";
      hash = "sha256-Hy/CkHdqGgtYSEeKNpRa7J2Im8rFjCAAWyIcRYF9W6k=";
    }
    {
      name = "Solar Eclipse Emergence from Orion.jpg";
      url = "https://images-assets.nasa.gov/image/art002e009299/art002e009299~orig.jpg";
      hash = "sha256-T1mi44LNuTVexEO96X4D5vnzVloT2StG+b0ggrAbtjU=";
    }
    {
      name = "Garden of Thorns.png";
      url = "https://w.wallhaven.cc/full/e8/wallhaven-e82j6o.png";
      hash = "sha256-QiyT2W4QvPJOmBReDQ45wB98k6pFXtUgq0FWusAdXzY=";
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
