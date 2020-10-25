{ config, pkgs, lib, ... }:
let
  user = "pn";
  home = "/home/${user}";
in
{
  # NixOS wants to enable GRUB by default
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;

  # "battle-tested" version
  #boot.kernelPackages = pkgs.linuxPackages_4_19;
  # linux v5.4
  boot.kernelPackages = pkgs.linuxPackages;

  # !!! Needed for the virtual console to work on the RPi 3, as the default of 16M doesn't seem to be enough.
  # If X.org behaves weirdly (I only saw the cursor) then try increasing this to 256M.
  # On a Raspberry Pi 4 with 4 GB, you should either disable this parameter or increase to at least 64M if you want the USB ports to work.
  boot.kernelParams = ["cma=32M"];

  # File systems configuration for using the installer's partition layout
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };
  };

  imports = [
  #  ./gemini.nix
    ./noip.nix
    ./spi.nix
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
  virtualisation.docker.enable = true;

  services.molly-brown = {
    enable = true;
    docBase = "${home}/gmi";
    hostName = "pn.hopto.org";
    certPath = "${home}/.gmi.keys/ca-cert.pem";
    keyPath = "${home}/.gmi.keys/ca-key.rsa";
  };

  environment.systemPackages = with pkgs; [
    git docker-compose
  ];

  environment.shellAliases = {
    cf = "vim ${home}/nixos/configuration.nix";
    nixos-rebuild = "sudo nixos-rebuild -I nixos-config=${home}/nixos/configuration.nix";
  };

  security.sudo.wheelNeedsPassword = false;

  users.users.pn = {
    inherit home;
    isNormalUser = true;
    extraGroups = [ "wheel" "users" "docker" "video" "networkmanager" ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCSgDwa2uv1zlAhuAaVtB+mdpiguhicJLplRmjpgvwMEiWjxXmROrfcWU/4Whs0Xyn9D1JhpkAAEqYoTKoTZB0luBwu2Q+QpDRsHXhWRrYCTT8qghBulRlKXBQ+TEvz/Jtmk6dwP6RAq1+Vviw/QCGj6Rb3bngyHJuLNrzy0lqdtgA17s1b3qqnNLRA3aDtCtsofGrX/XnEpHq916h1M8H5l6FcDb5mRrgLtxLsjX2lPPMUnF0Jj9eth9B6wvQKNKBAye0au648hF0RPxatNAbqTp3H7dZ8a9Y4X8OuyAbsNOaMLhsLLQ/s7KP7X9L2uz0D+5NHM0IkRTz3Mtk0TLpznanMekCY1IID0tL+VStRyogHJtz58dZFu7JT1/Q6OTteHbg/Q02uq0YnOxxi5Uc4rMhJ3ZodpKCZ5vXPllsfbpR3g0K1/bYsRB8HEqgd9dDD+3+MfW42PpS6JWsn9LzfRbhpYA/BFZFjq68pk//AAXcwjfiiao2zJ6nE1WxmyZKhLwqjWYry+29yOeoqgC4zLvXjKFkZ6I1rv/Rf2qvwNiC0YnIVZ9MGmGgng0BGTUeYEoTrWKldrr7pzJxHf52LOJbFZ+WffIUqgCqvzmVS6ntKnRSHOUSADMbM3pH2xt+g0WfO90oSb6xP28eqj+WEOd/2N7G2/VzGaAzjFMVf7Q== pniedzwiedzinski19@gmail.com"
    ];
  };
}
