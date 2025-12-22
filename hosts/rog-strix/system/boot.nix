# Boot configuration - systemd-boot, kernel, kernel params
{ pkgs, ... }: {
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

  # Early KMS (Kernel Mode Setting) - load NVIDIA driver early in boot
  # This fixes display issues when using PRIME sync/reverseSync modes
  boot.initrd.kernelModules = [ 
    "nvidia" 
    "nvidia_modeset" 
    "nvidia_uvm" 
    "nvidia_drm" 
  ];

  # Blacklist problematic kernel modules
  # spd5118: Memory controller driver that causes resume delays on ASUS laptops
  boot.blacklistedKernelModules = [ 
    "spd5118"
    
    # ═══════════════════════════════════════════════════════════════
    # MUX SWITCH CONFIGURATION - Intel GPU Driver Blacklisting
    # ═══════════════════════════════════════════════════════════════
    # DGPU MODE (current): Blacklist Intel GPU drivers
    "i915"     # Intel GPU driver
    "xe"       # New Intel GPU driver (Xe)
    
    # HYBRID MODE: Comment out i915 and xe above, then rebuild
    # boot.blacklistedKernelModules = [ "spd5118" ];
  ];

  # Kernel parameters
  boot.kernelParams = [
    # NVIDIA configuration (applies to both modes)
    "nvidia-drm.modeset=1"      # Enable modesetting for NVIDIA
    "nvidia-drm.fbdev=1"         # Enable fbdev for NVIDIA
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1"  # For suspend/resume

    # ═══════════════════════════════════════════════════════════════
    # MUX SWITCH CONFIGURATION - Intel GPU Kernel Parameters
    # ═══════════════════════════════════════════════════════════════
    # DGPU MODE (current): Disable Intel GPU
    "i915.modeset=0"                 # Disable Intel GPU modesetting
    "initcall_blacklist=i915_init"   # Prevent i915 from initializing
    
    # HYBRID MODE: Comment out the two i915 lines above, then rebuild

    # Hibernation resume (required for hibernate to work)
    "resume=/dev/disk/by-uuid/4d48cb91-7bfa-448e-bc21-93e228ddd729"

    # Suppress ACPI BIOS errors (harmless BIOS bugs, but noisy)
    "acpi.debug_level=0"
  ];
}

