# raspberry

My rpi3B config

## install

**Requirements**:
- NixOS or nix installed

0. change configuration in `./config`
1. run `build.sh` - at the end it will output store path to .img
2. dump image (`dd if=$image of=$device status=progress`)
  - You might be needed to resize the root partition to fill whole disk
4. insert sd into raspberry and boot
5. run `nixos-rebuild switch` to install
