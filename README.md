# NixOS Configuration — ROG Strix G16

Personal NixOS + home-manager configuration for ASUS ROG Strix G16 (G614, 2024) with RTX 4080.

## Structure

```
.
├── flake.nix                     # Main entry point
├── hosts/
│   └── rog-strix/                # Host-specific configuration
│       ├── configuration.nix     # Orchestrator
│       ├── hardware-configuration.nix
│       ├── system/               # Boot, disk, locale
│       ├── hardware/             # NVIDIA, ASUS, audio
│       ├── desktop/              # Plasma, portals
│       ├── programs/             # Gaming, development
│       └── services/             # Maintenance, power
├── home/
│   └── jens/                     # User configuration
│       ├── home.nix
│       ├── shell.nix
│       └── programs.nix
├── modules/                      # Reusable modules
├── overlays/                     # Package overlays
└── pkgs/                         # Custom packages
```

## Usage

```bash
# Rebuild system (includes home-manager)
sudo nixos-rebuild switch --flake .#rog-strix

# Update flake inputs
nix flake update

# Build without switching (test)
nixos-rebuild build --flake .#rog-strix
```

## First-time Setup

1. Generate hardware configuration:
   ```bash
   sudo nixos-generate-config --show-hardware-config > hosts/rog-strix/hardware-configuration.nix
   ```

2. Review and fill in TODO items in the configuration files

3. Add all files to git:
   ```bash
   git add .
   ```

4. Build and switch:
   ```bash
   sudo nixos-rebuild switch --flake .#rog-strix
   ```

## See Also

- [NIXOS-BUILD-ORDER.md](NIXOS-BUILD-ORDER.md) — Detailed build checklist with phase ordering
