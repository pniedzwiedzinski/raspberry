{ pkgs, ... }:
let
  configFile = ./noip2.conf;
in
  {
    system.activationScripts.noip = ''
      cat ${configFile} > /tmp/noip.conf
      ${pkgs.noip}/bin/noip2 -c /tmp/noip.conf
    '';
  }
