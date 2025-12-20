# ASUS ROG configuration - asusd, supergfxd, ROG controls
{ pkgs, ... }: {
  # ASUS system daemon (fan control, keyboard LEDs, etc.)
  services.asusd = {
    enable = true;
    enableUserService = true;
  };

  # GPU switching daemon (Hybrid/Integrated/dGPU modes)
  services.supergfxd.enable = true;

  # Fix for supergfxd needing lspci
  systemd.services.supergfxd.path = [ pkgs.pciutils ];

  # Power profiles daemon (integrates with asusd)
  services.power-profiles-daemon.enable = true;

  # TODO: Add ROG-specific packages
  # environment.systemPackages = with pkgs; [
  #   asusctl              # CLI for asusd
  #   supergfxctl          # CLI for supergfxd
  #   # supergfxctl-plasmoid # KDE widget (if available in nixpkgs)
  # ];
}

