# KDE Plasma 6 configuration
{ pkgs, ... }: {
  # Enable X11 (needed for some apps, SDDM, fallback)
  services.xserver.enable = true;

  # X11 configuration for NVIDIA
  services.xserver = {
    # Screen section for NVIDIA
    screenSection = ''
      Option "metamodes" "nvidia-auto-select +0+0 {ForceFullCompositionPipeline=On}"
      Option "AllowIndirectGLXProtocol" "off"
      Option "TripleBuffer" "on"
    '';
  };

  # Display manager
  services.displayManager.sddm = {
    enable = true;
    # ═══════════════════════════════════════════════════════════════
    # MUX SWITCH CONFIGURATION - Wayland/X11 Selection
    # ═══════════════════════════════════════════════════════════════
    # DGPU MODE (current): X11 is more stable
    wayland.enable = false;
    
    # HYBRID MODE: You can try Wayland if desired
    # wayland.enable = true;
  };

  # KDE Plasma 6
  services.desktopManager.plasma6.enable = true;

  # Default session
  # DGPU MODE (current): Use X11 for stability
  services.displayManager.defaultSession = "plasmax11";
  
  # HYBRID MODE: You can use Wayland if desired
  # services.displayManager.defaultSession = "plasma";  # Wayland

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

