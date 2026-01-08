# XDG portals, MIME handlers, secrets
# Shared module for desktop functionality
{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myConfig.desktop.portals.enable = lib.mkEnableOption "XDG portals and desktop integration (screen sharing, file dialogs, etc.)";

  config = lib.mkIf config.myConfig.desktop.portals.enable {
    # XDG portal (screen sharing, file dialogs, etc.)
    xdg.portal = {
      enable = true;
      # Use KDE portal for Plasma
      extraPortals = [pkgs.kdePackages.xdg-desktop-portal-kde];
    };

    # GVFS for file manager features (MTP, SMB, trash)
    services.gvfs.enable = true;

    # Secret service backend (for apps using libsecret like CodeRabbit)
    services.gnome.gnome-keyring.enable = true;
    # Disable GNOME's GCR SSH agent as it conflicts with programs.ssh.startAgent
    # which is used for KWallet integration in plasma.nix
    services.gnome.gcr-ssh-agent.enable = false;

    # Polkit (privilege escalation dialogs)
    security.polkit.enable = true;

    # D-Bus
    services.dbus.enable = true;

    # Ensure standard desktop utilities and libraries are available
    environment.systemPackages = with pkgs; [
      xdg-utils
      libsecret # Library for secret storage communication
    ];
  };
}
