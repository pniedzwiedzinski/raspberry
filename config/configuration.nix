{ config, pkgs, lib, ... }:
let
  user = "pn";
  home = "/home/${user}";
  sshKey = pkgs.runCommand "id_rsa.pub" {} ''
    echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCSgDwa2uv1zlAhuAaVtB+mdpiguhicJLplRmjpgvwMEiWjxXmROrfcWU/4Whs0Xyn9D1JhpkAAEqYoTKoTZB0luBwu2Q+QpDRsHXhWRrYCTT8qghBulRlKXBQ+TEvz/Jtmk6dwP6RAq1+Vviw/QCGj6Rb3bngyHJuLNrzy0lqdtgA17s1b3qqnNLRA3aDtCtsofGrX/XnEpHq916h1M8H5l6FcDb5mRrgLtxLsjX2lPPMUnF0Jj9eth9B6wvQKNKBAye0au648hF0RPxatNAbqTp3H7dZ8a9Y4X8OuyAbsNOaMLhsLLQ/s7KP7X9L2uz0D+5NHM0IkRTz3Mtk0TLpznanMekCY1IID0tL+VStRyogHJtz58dZFu7JT1/Q6OTteHbg/Q02uq0YnOxxi5Uc4rMhJ3ZodpKCZ5vXPllsfbpR3g0K1/bYsRB8HEqgd9dDD+3+MfW42PpS6JWsn9LzfRbhpYA/BFZFjq68pk//AAXcwjfiiao2zJ6nE1WxmyZKhLwqjWYry+29yOeoqgC4zLvXjKFkZ6I1rv/Rf2qvwNiC0YnIVZ9MGmGgng0BGTUeYEoTrWKldrr7pzJxHf52LOJbFZ+WffIUqgCqvzmVS6ntKnRSHOUSADMbM3pH2xt+g0WfO90oSb6xP28eqj+WEOd/2N7G2/VzGaAzjFMVf7Q== pniedzwiedzinski19@gmail.com" > $out
  '';
in
{
  imports = [
    ./rpi3-hardware.nix

#    ./gemini.nix
    ./noip.nix
    ./hyperion.nix
  ];


  networking.hostName = "rpi";
  networking.firewall.allowedTCPPorts = [
    # ssh
    22
    # pihole
    5999
    6000
    # gemini
    1965
    # hyperion
    19444
    19445
  ];

  time.timeZone = "Europe/Warsaw";

  programs.vim.defaultEditor = true;
  services.openssh.enable = true;
  services.openssh.authorizedKeysFiles = [ "${sshKey}" ];
  virtualisation.docker.enable = true;

  #services.molly-brown = {
    #enable = true;
    #docBase = "${home}/gmi";
    #hostName = "pn.hopto.org";
    #certPath = "${home}/.gmi.keys/ca-cert.pem";
    #keyPath = "${home}/.gmi.keys/ca-key.rsa";
  #};

  environment.systemPackages = with pkgs; [
    git docker-compose
  ];

  environment.shellAliases = {
    cf = "vim ${home}/raspberry/config/configuration.nix";
    nixos-rebuild = "sudo nixos-rebuild -I nixos-config=${home}/raspberry/config/configuration.nix";
    # nixos-rebuild = "sudo nixos-rebuild";
  };

  security.sudo.wheelNeedsPassword = false;

  users.users."${user}" = {
    inherit home;
    isNormalUser = true;
    extraGroups = [ "wheel" "users" "docker" "video" "networkmanager" ];
    openssh.authorizedKeys.keyFiles = [ "${sshKey}" ];
  };
}
