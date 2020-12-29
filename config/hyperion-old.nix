{ stdenv, fetchurl, autoPatchelfHook, callPackage,
expat, glib, systemd, libX11, libXrandr, fontconfig, tlf, ncurses5, bzip2,
readline70, openssl, db, libglvnd, libusb }:
with stdenv.lib;
let

  mpdecimal = callPackage ./mpdecimal.nix {};

  bzip2_linked = stdenv.mkDerivation {
    name = "bzip2-linked";
    unpackPhase = "true";
    installPhase = ''
      mkdir -p $out/lib
      cp -r ${bzip2.out}/lib/libbz2.so.1.0.6 $out/lib
      ln -s $out/lib/libbz2.so.1.0.6 $out/lib/libbz2.so.1.0
    '';
  };
in
stdenv.mkDerivation {
  name = "hyperion";

  src = fetchurl {
    url = "https://downloads.sourceforge.net/project/hyperion-project/release/hyperion_rpi3.tar.gz";
    sha256 = "04rf1q68b80pmb9m3pqmbr761hb3zpqsb7k2bjgd8x8kyw21dh6z";
  };

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [
    systemd
    stdenv.cc.cc.lib
    fontconfig.lib
    tlf
    ncurses5
    mpdecimal
    glib
    readline70
    openssl
    db
    libglvnd
    libusb
    expat
    libX11
    libXrandr

    bzip2_linked
  ];

  #sourceRoot = "share/hyperion";

  buildPhase = "";
  installPhase = ''
    mkdir -p $out/bin
    cp -r bin $out
  '';

  meta = {
    description = "Hyperion is an open source ambient light software. Feel free to join us and contribute new features!";
    homepage = "https://hyperion-project.org/";
  };
}
