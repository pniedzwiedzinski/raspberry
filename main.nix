{ pkgs, ... }:
let
  configFolder = ./config;
in
{
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/sd-image-aarch64.nix>
    "${toString configFolder}/configuration.nix"
  ];

  sdImage.compressImage = false;

  sdImage.populateRootCommands = ''
    mkdir -p ./files/etc/nixos
    for f in `ls ${configFolder}`; do
      cat ${configFolder}/$f > ./files/etc/nixos/$f
      chmod 644 ./files/etc/nixos/$f
    done
  '';

}
