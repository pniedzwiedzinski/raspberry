{ stdenv, fetchurl, gcc, systemd }:
with stdenv.lib;

stdenv.mkDerivation {
  name = "hyperion-ng";

  src = fetchurl {
    url = "https://github.com/hyperion-project/hyperion.ng/releases/download/2.0.0-alpha.8/Hyperion-2.0.0-alpha.8-Linux-aarch64.tar.gz";
    sha256 = "1f2gbzfyqw8kclq0lx1bajs4xfrq3f2x07jyxngv65a4pr5ppfxk";
  };

  buildInputs = [
    systemd
    gcc
  ];

  sourceRoot = "share/hyperion";

  buildPhase = "";
  installPhase = ''
    mkdir -p $out/bin $out/lib
    cp -r bin $out
    cp -r lib $out
  '';

  meta = {
    description = "Hyperion is an open source ambient light software. Feel free to join us and contribute new features!";
    homepage = "https://hyperion-project.org/";
  };
}
