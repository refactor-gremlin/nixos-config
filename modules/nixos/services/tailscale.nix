# Tailscale VPN configuration
# Shared Tailscale module for all hosts
{ config, lib, pkgs, ... }: {
  options.myConfig.services.tailscale.enable = lib.mkEnableOption "Tailscale VPN service";

  config = lib.mkIf config.myConfig.services.tailscale.enable {
    # Enable secrets management (provides the auth key)
    myConfig.secrets.enable = true;

    # Enable Tailscale service with automatic authentication
    services.tailscale = {
      enable = true;
      # Use the decrypted auth key from sops
      authKeyFile = config.sops.secrets.tailscale_auth_key.path;
    };

    # Fix autoconnect service timing - wait for tailscaled to be truly ready
    systemd.services.tailscaled-autoconnect = {
      # Wait a moment for tailscaled socket to be ready
      serviceConfig = {
        ExecStartPre = "${pkgs.coreutils}/bin/sleep 2";
        # Retry on failure
        Restart = "on-failure";
        RestartSec = "3s";
      };
      # Don't fail the entire activation if this fails
      unitConfig = {
        StartLimitIntervalSec = 30;
        StartLimitBurst = 3;
      };
    };

    # Open firewall for Tailscale
    networking.firewall = {
      # Trust the Tailscale interface
      trustedInterfaces = [ "tailscale0" ];
      # Allow Tailscale traffic
      checkReversePath = "loose";
    };
  };
}
