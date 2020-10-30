{ pkgs ? import <nixpkgs> {} }:
{
  hyperion = pkgs.callPackage ./config/hyperion-ng.nix { };
}
