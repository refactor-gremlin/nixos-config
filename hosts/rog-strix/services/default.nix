# Services configuration - maintenance, power, networking
{ ... }: {
  imports = [
    ./maintenance.nix
    ./power.nix
    ./tailscale.nix
  ];
}

