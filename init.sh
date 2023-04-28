#!/bin/bash

mkfs.fat -F 32 /dev/nvme1n1p1 
mkfs.ext4 /dev/nvme1n1p2

mount -t tmpfs none /mnt 
mkdir -p /mnt/{boot,nix,etc/nixos}
mount /dev/nvme1n1p2 /mnt/nix
mount /dev/nvme1n1p1 /mnt/boot 
mkdir -p /mnt/nix/persist/etc/nixos
mount -o bind /mnt/nix/persist/etc/nixos /mnt/etc/nixos

nixos-generate-config --root /mnt


nix-shell -p git
git clone  https://github.com/samos667/flakes-workstation.git /mnt/etc/nixos/Flakes 
cd /mnt/etc/nixos/Flakes/
nix develop --extra-experimental-features nix-command --extra-experimental-features flakes

cp /mnt/etc/nixos/hardware-configuration.nix /mnt/etc/nixos/Flakes/hosts/laptop/hardware-configuration.nix