{ pkgs, ... }:
{
  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball {
      url = "https://github.com/nix-community/NUR/archive/2c7ca9ac16f505d802099c4dfb1c2f02191ca349.tar.gz";
      sha256 = "1gs8vpbxsz0zq6c5mayczb3mjiw5daxl0dn8ppaxazs4sxh7lpzm";
    }) {
      inherit pkgs;
    };
  };

  systemd.services.gemini = {
    description = "Gemini protocol server";
    enable = true;
    wantedBy = [ "network-online.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.nur.repos.pn.agate}/bin/agate /home/pn/gmi /home/pn/.gmi.keys/ca-cert.pem /home/pn/.gmi.keys/ce-key.rsa";
      Restart = "on-failure";
    };
  };

}
