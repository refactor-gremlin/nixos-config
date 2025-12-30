# XDG portals, MIME handlers, secrets
# Shared module for desktop functionality
{ config, lib, pkgs, ... }: {
  options.myConfig.desktop.portals.enable = lib.mkEnableOption "XDG portals and desktop integration (screen sharing, file dialogs, etc.)";

  config = lib.mkIf config.myConfig.desktop.portals.enable {
    # XDG portal (screen sharing, file dialogs, etc.)
    xdg.portal = {
      enable = true;
      # Use Hyprland portal
      extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
      config.common.default = [ "gtk" ]; # Fallback
    };

    # GVFS for file manager features (MTP, SMB, trash)
    services.gvfs.enable = true;

    # Gnome Keyring (for saving WiFi passwords and other secrets)
    services.gnome.gnome-keyring.enable = true;

    # Polkit (privilege escalation dialogs)
    security.polkit.enable = true;

    # D-Bus
    services.dbus.enable = true;

    # Ensure xdg-open and auth agents are available
    environment.systemPackages = with pkgs; [
      xdg-utils
      polkit_gnome # Authentication agent
    ];
  };
}


