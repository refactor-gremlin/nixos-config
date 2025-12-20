# KDE Plasma 6 configuration
{ pkgs, ... }: {
  # Enable X11 (needed for some apps, SDDM, fallback)
  services.xserver.enable = true;

  # Display manager
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  # KDE Plasma 6
  services.desktopManager.plasma6.enable = true;

  # Default session (Wayland)
  services.displayManager.defaultSession = "plasma";

  # Exclude some default KDE apps if desired
  # environment.plasma6.excludePackages = with pkgs.kdePackages; [
  #   elisa       # Music player
  #   konsole     # Terminal (if using different terminal)
  # ];

  # TODO: Additional Plasma packages
  # environment.systemPackages = with pkgs; [
  #   kdePackages.kde-gtk-config    # GTK theme integration
  #   kdePackages.breeze-gtk        # Breeze theme for GTK
  # ];
}

