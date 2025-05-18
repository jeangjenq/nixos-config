{ pkgs, lib, stdenv, ... }:

let
  _pname = "rez";
  _version = "3.2.1";

in

pkgs.stdenv.mkDerivation rec {
  pname = "${_pname}";
  version = "${_version}";
  name = "${pname}-${version}";
  
  meta = with lib; {
    description = "Rez is a cross-platform package manager";
    homepage = "https://github.com/AcademySoftwareFoundation/rez";
    platforms = platforms.linux;
  };

  src = fetchTarball {
    url = "https://github.com/AcademySoftwareFoundation/${pname}/archive/refs/tags/${version}.tar.gz";
    sha256 = "sha256:0by1vm9gxdk0kxsqrjmcgk827wdbqk4d1m5zbszrfl0p271cc758";
  };

  buildInputs = with pkgs;
  [
    which
    tree
    bc
    python310
    python310Packages.pip
    python310Packages.setuptools
  ];

  dontBuild = true;
  dontConfigure = true;

  dontUnpack = false;
  dontInstall = false;
  dontFixup = false;

  installPhase = ''
    # runHook preInstall
    mkdir -p $out/share/rez/src/
    mkdir -p $out/share/rez/env/
    cp -r $src/* $out/share/rez/src/
    cd $out/share/rez/src/
    ${pkgs.python310}/bin/python3.10 ./install.py $out/share/rez/env/
    # runHook postInstall
  '';
}