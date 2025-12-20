# System configuration - boot, disk, locale
{ ... }: {
  imports = [
    ./boot.nix
    ./disk.nix
    ./locale.nix
  ];
}

