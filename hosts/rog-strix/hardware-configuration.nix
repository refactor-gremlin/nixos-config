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

  # PLACEHOLDER FILESYSTEMS - Replace with output of nixos-generate-config
  # These allow the config to pass validation but WILL NOT BOOT
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/PLACEHOLDER-ROOT-UUID";
    fsType = "btrfs";
    options = ["subvol=@" "compress=zstd" "noatime"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/PLACEHOLDER-EFI-UUID";
    fsType = "vfat";
  };

  swapDevices = [];

  # TODO: Uncomment and fill with real UUIDs after running:
  #   sudo nixos-generate-config --show-hardware-config
  #
  # fileSystems."/home" = {
  #   device = "/dev/disk/by-uuid/YOUR-ROOT-UUID";
  #   fsType = "btrfs";
  #   options = ["subvol=@home" "compress=zstd" "noatime"];
  # };
  #
  # fileSystems."/nix" = {
  #   device = "/dev/disk/by-uuid/YOUR-ROOT-UUID";
  #   fsType = "btrfs";
  #   options = ["subvol=@nix" "compress=zstd" "noatime"];
  # };
  #
  # swapDevices = [
  #   { device = "/dev/disk/by-uuid/YOUR-SWAP-UUID"; }
  # ];

  # Enable firmware
  hardware.enableRedistributableFirmware = lib.mkDefault true;

  # CPU
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}

