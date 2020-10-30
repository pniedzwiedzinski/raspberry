{ stdenv, fetchurl, gcc, systemd, libX11, libXrandr }:
with stdenv.lib;
let
  srcAarch64 = fetchurl {
    url = "https://github.com/hyperion-project/hyperion.ng/releases/download/2.0.0-alpha.8/Hyperion-2.0.0-alpha.8-Linux-aarch64.tar.gz";
    sha256 = "1f2gbzfyqw8kclq0lx1bajs4xfrq3f2x07jyxngv65a4pr5ppfxk";
  };

  srcX86 = fetchurl {
    url = "https://github.com/hyperion-project/hyperion.ng/releases/download/2.0.0-alpha.8/Hyperion-2.0.0-alpha.8-Linux-x86_64.tar.gz";
    sha256 = "1gkjzqkh6qbwzkrdrg9xmznh6b676kmdlw54drqwfycakb7riad2";
  };
in
stdenv.mkDerivation {
  name = "hyperion-ng";

  src = srcX86;

  buildInputs = [
    systemd
    gcc
    libX11
    libXrandr
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
