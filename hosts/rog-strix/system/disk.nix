# Disk configuration - Btrfs, LUKS, swap, resume
{ ... }: {
  # Btrfs options
  # Note: Actual mount points are in hardware-configuration.nix
  # This file contains additional Btrfs-related settings

  # Enable periodic TRIM for SSDs
  services.fstrim = {
    enable = true;
    interval = "weekly";
  };

  # Swap configuration
  # TODO: Configure swap for hibernation
  # swapDevices = [
  #   {
  #     device = "/dev/disk/by-uuid/YOUR-SWAP-UUID";
  #     # Or use a swapfile on Btrfs (requires specific setup)
  #   }
  # ];

  # Hibernation resume
  # TODO: Set resume device for hibernation
  # boot.resumeDevice = "/dev/disk/by-uuid/YOUR-SWAP-UUID";

  # Btrfs scrub (monthly integrity check)
  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
    fileSystems = ["/"];
  };
}

