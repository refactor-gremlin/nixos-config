# NVIDIA configuration - drivers, PRIME, modesetting
# This file automatically configures based on hardware.gpuMode setting
{ config, pkgs, lib, ... }: 

let
  mode = config.hardware.gpuMode;
  isDedicated = mode == "dedicated";
  isHybrid = mode == "hybrid";
  isIntegrated = mode == "integrated";
in {
  # Enable OpenGL
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # NVIDIA driver (disabled in integrated mode)
  services.xserver.videoDrivers = lib.mkIf (!isIntegrated) ["nvidia"];

  hardware.nvidia = lib.mkIf (!isIntegrated) {
    # Modesetting is required for Wayland
    modesetting.enable = true;

    # Power management
    powerManagement = {
      enable = true;
      # Fine-grained power management (Turing+)
      # Enable in integrated mode to fully power off NVIDIA
      finegrained = isIntegrated;
    };

    # Use open source kernel module (not nouveau, NVIDIA's open kernel module)
    # Only for Turing+ (RTX 20xx, 30xx, 40xx)
    open = false;

    # NVIDIA settings GUI
    nvidiaSettings = true;

    # Driver version
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    # ═══════════════════════════════════════════════════════════════
    # PRIME Configuration - Automatic based on mode
    # ═══════════════════════════════════════════════════════════════
    # Mode is controlled by hardware.gpuMode in gpu-mode.nix
    
    prime = lib.mkIf isHybrid {
      # Reverse sync - NVIDIA always renders, Intel outputs
      # Better performance than offload for high refresh displays
      reverseSync.enable = true;
      
      # Bus IDs verified with: lspci | grep -E 'VGA|3D'
      intelBusId = "PCI:0:2:0";   # Intel iGPU
      nvidiaBusId = "PCI:1:0:0";  # NVIDIA RTX 4080
    };
  };

  # Environment variables - automatic based on mode
  environment.sessionVariables = lib.mkMerge [
    # Wayland variables (all modes)
    {
      NIXOS_OZONE_WL = "1";  # Electron apps use Wayland
    }
    
    # NVIDIA-specific variables (dedicated and hybrid modes)
    (lib.mkIf (!isIntegrated) {
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      LIBVA_DRIVER_NAME = "nvidia";
      GBM_BACKEND = "nvidia-drm";
      WLR_NO_HARDWARE_CURSORS = "1";
    })
  ];
}

