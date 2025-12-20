# Services configuration - maintenance, power
{ ... }: {
  imports = [
    ./maintenance.nix
    ./power.nix
  ];
}

