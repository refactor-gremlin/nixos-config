# NVIDIA configuration - drivers, PRIME, modesetting
{ config, pkgs, ... }: {
  # Enable OpenGL
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # NVIDIA driver
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    # Modesetting is required for Wayland
    modesetting.enable = true;

    # Power management (experimental)
    powerManagement = {
      enable = true;
      # Fine-grained power management (Turing+)
      finegrained = false;  # Set to true for better battery, but may cause issues
    };

    # Use open source kernel module (not nouveau, NVIDIA's open kernel module)
    # Only for Turing+ (RTX 20xx, 30xx, 40xx)
    # Keeping false for stability - open module is still experimental
    open = false;

    # NVIDIA settings GUI
    nvidiaSettings = true;

    # Driver version
    # Using stable for better reliability
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    # package = config.boot.kernelPackages.nvidiaPackages.beta;

    # ═══════════════════════════════════════════════════════════════
    # MUX SWITCH CONFIGURATION - PRIME Settings
    # ═══════════════════════════════════════════════════════════════
    # This laptop has a hardware MUX switch that completely disables one GPU
    #
    # DGPU MODE (current): No PRIME config needed - NVIDIA is the only GPU
    # HYBRID MODE: Uncomment the prime block below
    
    # Uncomment for HYBRID MODE (iGPU active):
    # prime = {
    #   # Offload mode - iGPU by default, dGPU on demand
    #   offload = {
    #     enable = true;
    #     enableOffloadCmd = true;  # Adds `nvidia-offload` command
    #   };
    #
    #   # Bus IDs verified with: lspci | grep -E 'VGA|3D'
    #   # Intel iGPU: 00:02.0 → PCI:0:2:0
    #   # NVIDIA RTX 4080: 01:00.0 → PCI:1:0:0
    #   intelBusId = "PCI:0:2:0";   # Intel iGPU bus ID
    #   nvidiaBusId = "PCI:1:0:0";  # NVIDIA RTX 4080 bus ID
    # };
  };

  # Environment variables
  environment.sessionVariables = {
    # NVIDIA-specific variables (applies to both modes)
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    LIBVA_DRIVER_NAME = "nvidia";
    
    # ═══════════════════════════════════════════════════════════════
    # Optional: Wayland environment variables for HYBRID MODE
    # ═══════════════════════════════════════════════════════════════
    # Uncomment these if you want to use Wayland in hybrid mode:
    # NIXOS_OZONE_WL = "1";              # Electron apps use Wayland
    # GBM_BACKEND = "nvidia-drm";        # GBM backend for NVIDIA
    # WLR_NO_HARDWARE_CURSORS = "1";     # Fix for some Wayland compositors
    # KWIN_DRM_USE_MODIFIERS = "0";      # Fix Plasma 6 on NVIDIA Wayland
  };
}

