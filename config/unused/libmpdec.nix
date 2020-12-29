{ stdenv, fetchurl }:
with stdenv.lib;

stdenv.mkDerivation {
  pname = "libmpdec";
  version = "2.5.0";

  src = fetchurl {
    url = "http://www.bytereef.org/software/mpdecimal/releases/mpdecimal-2.5.0.tar.gz";
    sha256 = "15417edc8e12a57d1d9d75fa7e3f22b158a3b98f44db9d694cfd2acde8dfa0ca";
  };

  buildPhase = ''
    ./configure
    sed -i 's:#/bin/sh:${stdenv.shell}/bin/sh:' tests/gettests.sh
    cd libmpdec
    sed -i 's/-Wl,-soname,/-soname /' Makefile
    make
  '';

  installPhase = ''
    mkdir -p $out/lib
    cp libmpdec.so $out/lib
    cp libmpdec.so.2 $out/lib
    cp libmpdec.so.2.5.0 $out/lib
  '';

}
