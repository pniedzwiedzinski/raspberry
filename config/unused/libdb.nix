{ stdenv, fetchurl }:
with stdenv.lib;

let
  pname = "libdb";
  version = "5.3.28";
in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://github.com/berkeleydb/libdb/releases/download/v5.3.28/db-5.3.28.tar.gz";
    sha256 = "0a1n5hbl7027fbz5lm0vp0zzfp1hmxnz14wx3zl9563h83br5ag0";
  };

  buildPhase = ''
    ./dist/configure
    make
  '';

  installPhase = ''
    mkdir -p $out/lib
    sed -i 's:/usr/local/BerkeleyDB.5.3:$out:' Makefile
    make library_install libdir=$out/lib
  '';
}
