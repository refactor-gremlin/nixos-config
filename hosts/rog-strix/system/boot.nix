# Boot configuration - systemd-boot, kernel, kernel params
# This file automatically configures based on hardware.gpuMode setting
{ config, pkgs, lib, ... }: 

let
  mode = config.hardware.gpuMode;
  isDedicated = mode == "dedicated";
  isHybrid = mode == "hybrid";
  isIntegrated = mode == "integrated";
in {
  # Bootloader
  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 10;
      editor = false;  # Disable editing boot entries for security
    };
    efi.canTouchEfiVariables = true;
    timeout = 3;
  };

  # Kernel
  # CachyOS kernel (gaming-optimized with performance patches)
  # Access through chaotic overlay (added in configuration.nix)
  # Note: linuxPackages_cachyos is already a packages set, not a kernel source
  boot.kernelPackages = pkgs.linuxPackages_cachyos;
  # Alternatives:
  # boot.kernelPackages = pkgs.linuxPackages_latest;  # Latest stable
  # boot.kernelPackages = pkgs.linuxPackages_6_12;    # Specific version

  # Hibernation resume device (swap partition)
  # Swap is configured in hardware-configuration.nix
  boot.resumeDevice = "/dev/disk/by-uuid/4d48cb91-7bfa-448e-bc21-93e228ddd729";

  # Early KMS (Kernel Mode Setting) - load drivers early in boot
  boot.initrd.kernelModules = 
    # NVIDIA modules (dedicated and hybrid modes)
    lib.optionals (!isIntegrated) [
      "nvidia" 
      "nvidia_modeset" 
      "nvidia_uvm" 
      "nvidia_drm"
    ] ++
    # Intel modules (hybrid and integrated modes)
    lib.optionals (!isDedicated) [
      "i915"
    ];

  # Blacklist problematic kernel modules - automatic based on mode
  boot.blacklistedKernelModules = [ 
    "spd5118"  # Memory controller driver that causes resume delays
  ] ++ 
  # Blacklist Intel GPU in dedicated mode only
  lib.optionals isDedicated [
    "i915"  # Intel GPU driver
    "xe"    # New Intel GPU driver (Xe)
  ] ++
  # Blacklist NVIDIA in integrated mode only
  lib.optionals isIntegrated [
    "nvidia"
    "nvidia_drm"
    "nvidia_modeset"
  ];

  # Kernel parameters - automatic based on mode
  boot.kernelParams = [
    # Hibernation resume (all modes)
    "resume=/dev/disk/by-uuid/4d48cb91-7bfa-448e-bc21-93e228ddd729"
    
    # Suppress ACPI BIOS errors (all modes)
    "acpi.debug_level=0"
  ] ++
  # NVIDIA parameters (dedicated and hybrid modes)
  lib.optionals (!isIntegrated) [
    "nvidia-drm.modeset=1"
    "nvidia-drm.fbdev=1"
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
  ] ++
  # Disable Intel GPU (dedicated mode only)
  lib.optionals isDedicated [
    "i915.modeset=0"
    "initcall_blacklist=i915_init"
  ];
}

