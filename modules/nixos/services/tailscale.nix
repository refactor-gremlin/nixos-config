# Tailscale VPN configuration
# Shared Tailscale module for all hosts
{ config, lib, ... }: {
  options.myConfig.services.tailscale.enable = lib.mkEnableOption "Tailscale VPN service";

  config = lib.mkIf config.myConfig.services.tailscale.enable {
    # Enable Tailscale service
    services.tailscale.enable = true;

    # Open firewall for Tailscale
    networking.firewall = {
      # Trust the Tailscale interface
      trustedInterfaces = [ "tailscale0" ];
      # Allow Tailscale traffic
      checkReversePath = "loose";
    };
  };
}


