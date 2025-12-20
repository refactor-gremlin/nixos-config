# Hardware configuration placeholder
# Replace this file with the output of:
#   sudo nixos-generate-config --show-hardware-config > hosts/rog-strix/hardware-configuration.nix
#
# Or copy from /etc/nixos/hardware-configuration.nix after installation
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # TODO: Replace with your actual hardware configuration
  # These are placeholder values - they WILL NOT WORK until replaced

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];

  # TODO: Replace with your actual disk UUIDs
  # fileSystems."/" = {
  #   device = "/dev/disk/by-uuid/YOUR-ROOT-UUID";
  #   fsType = "btrfs";
  #   options = ["subvol=@" "compress=zstd" "noatime"];
  # };

  # fileSystems."/home" = {
  #   device = "/dev/disk/by-uuid/YOUR-ROOT-UUID";
  #   fsType = "btrfs";
  #   options = ["subvol=@home" "compress=zstd" "noatime"];
  # };

  # fileSystems."/nix" = {
  #   device = "/dev/disk/by-uuid/YOUR-ROOT-UUID";
  #   fsType = "btrfs";
  #   options = ["subvol=@nix" "compress=zstd" "noatime"];
  # };

  # fileSystems."/boot" = {
  #   device = "/dev/disk/by-uuid/YOUR-EFI-UUID";
  #   fsType = "vfat";
  # };

  # swapDevices = [
  #   { device = "/dev/disk/by-uuid/YOUR-SWAP-UUID"; }
  # ];

  # Enable firmware
  hardware.enableRedistributableFirmware = lib.mkDefault true;

  # CPU
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}

