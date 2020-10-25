{ pkgs, ... }:
let
  configFolder = ./config;
in
{
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/sd-image-aarch64.nix>
    "${toString configFolder}/config.nix"
  ];

  sdImage.compressImage = false;

  sdImage.populateRootCommands = ''
    mkdir -p ./files/etc
    cp -r ${configFolder} ./files/etc/nixos
  '';

}
