{
  description = "Multi-host NixOS configuration";

  inputs = {
    # Nixpkgs - using unstable for latest Plasma 6, kernel 6.12+, drivers
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Keep a stable reference for packages that need it
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";

    # Home Manager - following nixpkgs
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # HyDeNix - NixOS implementation of HyDE
    hydenix = {
      url = "github:richen604/hydenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
      # Ensure all hydenix sub-inputs use the same nixpkgs to avoid GLIBCXX mismatches
      inputs.hyq.inputs.nixpkgs.follows = "nixpkgs";
      inputs.hyde-ipc.inputs.nixpkgs.follows = "nixpkgs";
      inputs.hydectl.inputs.nixpkgs.follows = "nixpkgs";
      inputs.hyde-config.inputs.nixpkgs.follows = "nixpkgs";
    };

    # Chaotic-nyx for CachyOS kernel (gaming-optimized)
    chaotic = {
      url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Codex CLI (OpenAI Codex command-line tool)
    codex-cli = {
      url = "github:sadjow/codex-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nix-ai-tools (includes Factory AI's droid CLI)
    nix-ai-tools = {
      url = "github:numtide/nix-ai-tools";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # sops-nix for secrets management
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    hydenix,
    chaotic,
    codex-cli,
    nix-ai-tools,
    sops-nix,
    ...
  } @ inputs: let
    # Systems you want to support
    supportedSystems = ["x86_64-linux" "aarch64-linux"];

    # Helper function to generate attributes for all systems
    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

    # Nixpkgs instantiated for each system (with unfree allowed)
    pkgsFor = system:
      import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
  in rec {
    # Custom packages - available for all supported systems
    packages = forAllSystems (system: import ./pkgs (pkgsFor system)) // {
      x86_64-linux = (forAllSystems (system: import ./pkgs (pkgsFor system))).x86_64-linux // {
        # ISO images for all hosts
        server-01-iso = nixosConfigurations.server-01-iso.config.system.build.isoImage;
        pc-02-iso = nixosConfigurations.pc-02-iso.config.system.build.isoImage;
        rog-strix-iso = nixosConfigurations.rog-strix-iso.config.system.build.isoImage;
      };
    };

    # Formatter for nix files - available for all supported systems
    formatter = forAllSystems (system: (pkgsFor system).alejandra);

    # Overlays
    overlays = import ./overlays {inherit inputs;} // {
      # Workaround for hyprquery build failure
      fix-hyq = final: prev: {
        hyq = final.writeShellScriptBin "hyq" "exit 0";
      };
    };

    # NixOS configurations - add new hosts here
    nixosConfigurations = {
      # ═══════════════════════════════════════════════════════════════
      # ROG Strix G16 laptop - Jens
      # Intel CPU + NVIDIA GPU with ASUS-specific features
      # ═══════════════════════════════════════════════════════════════
      rog-strix = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          # HyDeNix NixOS module
          hydenix.nixosModules.default
          # Chaotic-nyx module (provides CachyOS kernel and gaming packages)
          chaotic.nixosModules.default
          # sops-nix for secrets management
          sops-nix.nixosModules.sops
          # All NixOS modules (options & profiles)
          ./modules/nixos/default.nix
          # Host configuration
          ./hosts/rog-strix/configuration.nix
          # Home Manager
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";
              extraSpecialArgs = {inherit inputs;};
              users.jens = import ./home/jens.nix;
              sharedModules = [
                sops-nix.homeManagerModules.sops
              ];
            };
          }
        ];
      };

      # ═══════════════════════════════════════════════════════════════
      # PC-02 Desktop - Lisa
      # AMD CPU + NVIDIA GPU desktop
      # ═══════════════════════════════════════════════════════════════
      pc-02 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          # HyDeNix NixOS module
          hydenix.nixosModules.default
          # sops-nix for secrets management
          sops-nix.nixosModules.sops
          # All NixOS modules (options & profiles)
          ./modules/nixos/default.nix
          # Host configuration
          ./hosts/pc-02/configuration.nix
          # Home Manager
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";
              extraSpecialArgs = {inherit inputs;};
              users.lisa = import ./home/lisa.nix;
              sharedModules = [
                sops-nix.homeManagerModules.sops
              ];
            };
          }
        ];
      };

      # ═══════════════════════════════════════════════════════════════
      # Server-01 - Headless Server
      # General purpose server with Docker, Tailscale, and essential tools
      # ═══════════════════════════════════════════════════════════════
      server-01 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          # HyDeNix NixOS module (required as it's imported in modules/nixos/default.nix)
          hydenix.nixosModules.default
          # sops-nix for secrets management
          sops-nix.nixosModules.sops
          # All NixOS modules (options & profiles)
          ./modules/nixos/default.nix
          # Host configuration
          ./hosts/server-01/configuration.nix
        ];
      };

      # ═══════════════════════════════════════════════════════════════
      # ISO Images - Bootable installation media
      # ═══════════════════════════════════════════════════════════════

      # Server-01 ISO - bootable installation image
      server-01-iso = let
        pkgs = pkgsFor "x86_64-linux";
      in nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          # HyDeNix NixOS module (required as it's imported in modules/nixos/default.nix)
          hydenix.nixosModules.default
          # ISO installer modules
          "${pkgs.path}/nixos/modules/installer/cd-dvd/iso-image.nix"
          # sops-nix for secrets management
          sops-nix.nixosModules.sops
          # All NixOS modules (options & profiles)
          ./modules/nixos/default.nix
          # Host configuration
          ./hosts/server-01/configuration.nix
        ];
      };

      # PC-02 ISO - Lisa's desktop installation image (with NVIDIA)
      pc-02-iso = let
        pkgs = pkgsFor "x86_64-linux";
      in nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          # HyDeNix NixOS module
          hydenix.nixosModules.default
          # ISO installer modules
          "${pkgs.path}/nixos/modules/installer/cd-dvd/iso-image.nix"
          # sops-nix for secrets management
          sops-nix.nixosModules.sops
          # All NixOS modules (options & profiles)
          ./modules/nixos/default.nix
          # Host configuration
          ./hosts/pc-02/configuration.nix
          # Home Manager
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";
              extraSpecialArgs = {inherit inputs;};
              users.lisa = import ./home/lisa.nix;
              sharedModules = [
                sops-nix.homeManagerModules.sops
              ];
            };
          }
        ];
      };

      # ROG Strix ISO - Jens' laptop installation image (with NVIDIA + CachyOS)
      rog-strix-iso = let
        pkgs = pkgsFor "x86_64-linux";
      in nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          # HyDeNix NixOS module
          hydenix.nixosModules.default
          # ISO installer modules
          "${pkgs.path}/nixos/modules/installer/cd-dvd/iso-image.nix"
          # Chaotic-nyx module (provides CachyOS kernel and gaming packages)
          chaotic.nixosModules.default
          # sops-nix for secrets management
          sops-nix.nixosModules.sops
          # All NixOS modules (options & profiles)
          ./modules/nixos/default.nix
          # Host configuration
          ./hosts/rog-strix/configuration.nix
          # Home Manager
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";
              extraSpecialArgs = {inherit inputs;};
              users.jens = import ./home/jens.nix;
              sharedModules = [
                sops-nix.homeManagerModules.sops
              ];
            };
          }
        ];
      };
    };
  };
}
