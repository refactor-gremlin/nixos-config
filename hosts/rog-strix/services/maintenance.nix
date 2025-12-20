# Maintenance configuration - Snapper, GC, fwupd
{ ... }: {
  # Nix garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  # Nix store optimization (deduplication)
  nix.settings.auto-optimise-store = true;

  # Firmware updates (LVFS)
  services.fwupd.enable = true;

  # TODO: Snapper for Btrfs snapshots
  # services.snapper = {
  #   snapshotInterval = "hourly";
  #   cleanupInterval = "1d";
  #   configs = {
  #     root = {
  #       SUBVOLUME = "/";
  #       ALLOW_USERS = ["jens"];
  #       TIMELINE_CREATE = true;
  #       TIMELINE_CLEANUP = true;
  #       TIMELINE_LIMIT_HOURLY = 10;
  #       TIMELINE_LIMIT_DAILY = 7;
  #       TIMELINE_LIMIT_WEEKLY = 4;
  #       TIMELINE_LIMIT_MONTHLY = 6;
  #       TIMELINE_LIMIT_YEARLY = 0;
  #     };
  #   };
  # };

  # Note: Btrfs scrub is configured in disk.nix
}

