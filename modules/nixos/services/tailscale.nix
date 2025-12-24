# Tailscale VPN configuration
# Shared Tailscale module for all hosts
{ config, lib, ... }: {
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

    # Open firewall for Tailscale
    networking.firewall = {
      # Trust the Tailscale interface
      trustedInterfaces = [ "tailscale0" ];
      # Allow Tailscale traffic
      checkReversePath = "loose";
    };
  };
}
