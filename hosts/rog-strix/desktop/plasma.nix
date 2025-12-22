# KDE Plasma 6 configuration
# This file automatically configures based on hardware.gpuMode setting
{ config, pkgs, lib, ... }: 

let
  mode = config.hardware.gpuMode;
  isDedicated = mode == "dedicated";
  isIntegrated = mode == "integrated";
in {
  # Enable X11 (needed for some apps, SDDM, fallback)
  services.xserver = {
    enable = true;
    
    # Exclude default X11 packages we don't want
    excludePackages = [ pkgs.xterm ];
    
    # X11 configuration for NVIDIA (dedicated mode only)
    # Screen section for NVIDIA - optimizations for direct display output
    screenSection = lib.mkIf isDedicated ''
      Option "metamodes" "nvidia-auto-select +0+0 {ForceFullCompositionPipeline=On}"
      Option "AllowIndirectGLXProtocol" "off"
      Option "TripleBuffer" "on"
    '';
  };

  # Display manager
  services.displayManager.sddm = {
    enable = true;
    # Wayland enabled for all modes (works well with current drivers)
    wayland.enable = true;
  };

  # KDE Plasma 6
  services.desktopManager.plasma6.enable = true;

  # Default session - Wayland (all modes support it)
  services.displayManager.defaultSession = "plasma";

  # Autostart applications
  # Note: These will start automatically when logging into Plasma
  xdg.autostart.enable = true;
  environment.etc = {
    "xdg/autostart/vesktop.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=Vesktop
      Exec=vesktop
      X-KDE-autostart-after=panel
    '';
    "xdg/autostart/cursor.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=Cursor
      Exec=cursor
      X-KDE-autostart-after=panel
    '';
    "xdg/autostart/chrome.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=Google Chrome
      Exec=google-chrome-stable
      X-KDE-autostart-after=panel
    '';
    "xdg/autostart/konsole.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=Konsole
      Exec=konsole
      X-KDE-autostart-after=panel
    '';
  };

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

