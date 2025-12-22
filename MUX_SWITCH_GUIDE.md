# MUX Switch Configuration Guide

This guide explains how to switch between dGPU-only and hybrid GPU modes on your ROG Strix laptop.

## Current Mode: **dGPU Mode** (NVIDIA RTX 4080 only)

---

## Quick Reference: What Changes Between Modes

| Configuration | dGPU Mode | Hybrid Mode |
|--------------|-----------|-------------|
| Intel GPU drivers | Blacklisted | Enabled |
| PRIME configuration | Disabled | Enabled (offload) |
| Display protocol | X11 | X11 or Wayland |
| Intel GPU kernel params | Disabled (`i915.modeset=0`) | Enabled (remove params) |

---

## Switching to Hybrid Mode

Follow these steps **AFTER** switching the MUX switch in BIOS/Armoury Crate to Hybrid mode:

### Step 1: Edit `hosts/rog-strix/system/boot.nix`

**Remove Intel GPU from blacklist:**
```nix
# Change this:
boot.blacklistedKernelModules = [ 
  "spd5118"
  "i915"     # Remove this line
  "xe"       # Remove this line
];

# To this:
boot.blacklistedKernelModules = [ 
  "spd5118"
];
```

**Remove Intel GPU disable kernel parameters:**
```nix
# Remove or comment out these two lines:
"i915.modeset=0"                 
"initcall_blacklist=i915_init"   
```

### Step 2: Edit `hosts/rog-strix/hardware/nvidia.nix`

**Enable PRIME offload configuration:**
```nix
# Uncomment the entire prime block:
prime = {
  offload = {
    enable = true;
    enableOffloadCmd = true;
  };
  intelBusId = "PCI:0:2:0";
  nvidiaBusId = "PCI:1:0:0";
};
```

**Optional - Enable Wayland environment variables:**
```nix
# Uncomment these if you want Wayland support:
NIXOS_OZONE_WL = "1";
GBM_BACKEND = "nvidia-drm";
WLR_NO_HARDWARE_CURSORS = "1";
KWIN_DRM_USE_MODIFIERS = "0";
```

### Step 3: Edit `hosts/rog-strix/desktop/plasma.nix` (Optional)

If you want to use Wayland in hybrid mode:

```nix
# Change:
wayland.enable = false;
services.displayManager.defaultSession = "plasmax11";

# To:
wayland.enable = true;
services.displayManager.defaultSession = "plasma";  # Wayland
```

**Note:** X11 works fine in hybrid mode too, so this is optional.

### Step 4: Rebuild and Reboot

```bash
cd /etc/nixos
sudo nixos-rebuild switch --flake '.#rog-strix'
sudo reboot
```

### Step 5: Test Hybrid Mode

After reboot, verify both GPUs are detected:
```bash
lspci | grep -E 'VGA|3D'
# Should show both Intel and NVIDIA GPUs

# To run a program on NVIDIA GPU in hybrid mode:
nvidia-offload glxinfo | grep "OpenGL renderer"
```

---

## Switching to dGPU Mode

Follow these steps **AFTER** switching the MUX switch in BIOS/Armoury Crate to dGPU mode:

### Step 1: Edit `hosts/rog-strix/system/boot.nix`

**Add Intel GPU to blacklist:**
```nix
boot.blacklistedKernelModules = [ 
  "spd5118"
  "i915"     # Add this
  "xe"       # Add this
];
```

**Add Intel GPU disable kernel parameters:**
```nix
boot.kernelParams = [
  # ... other params ...
  "i915.modeset=0"
  "initcall_blacklist=i915_init"
];
```

### Step 2: Edit `hosts/rog-strix/hardware/nvidia.nix`

**Disable PRIME configuration:**
```nix
# Comment out the entire prime block
# (it should already be commented in dGPU mode)
```

### Step 3: Edit `hosts/rog-strix/desktop/plasma.nix`

**Use X11 for stability:**
```nix
wayland.enable = false;
services.displayManager.defaultSession = "plasmax11";
```

### Step 4: Rebuild and Reboot

```bash
cd /etc/nixos
sudo nixos-rebuild switch --flake '.#rog-strix'
sudo reboot
```

### Step 5: Test dGPU Mode

After reboot:
```bash
lspci | grep -E 'VGA|3D'
# Should show only NVIDIA GPU

nvidia-smi
# Should show your RTX 4080 active
```

---

## Important Notes

### Do NOT Mix Configurations!

❌ **Never** have PRIME enabled when Intel GPU is blacklisted  
❌ **Never** have Intel GPU enabled without PRIME in hybrid mode  
✅ **Always** match NixOS config to BIOS MUX switch setting

### MUX Switch Locations

- **BIOS:** Advanced → Graphics Configuration → GPU Switch
- **Armoury Crate:** System → Operating Mode → GPU mode

### Performance Tips

**dGPU Mode:**
- Best gaming performance
- Worse battery life
- Recommended for desktop/plugged-in use

**Hybrid Mode:**
- Better battery life (iGPU for desktop, dGPU on demand)
- Slightly more complex
- Recommended for mobile use
- Use `nvidia-offload <command>` to run specific programs on dGPU

### Troubleshooting

**Black screen in dGPU mode:**
- Make sure Intel GPU drivers are blacklisted
- Make sure `i915.modeset=0` is set
- Use X11, not Wayland

**Black screen in hybrid mode:**
- Make sure Intel GPU drivers are NOT blacklisted
- Make sure `i915.modeset=0` is removed
- Make sure PRIME offload is enabled
- Intel GPU must be active for display output

**TTYs not working:**
- Check that early KMS is loaded: `boot.initrd.kernelModules`
- Check kernel logs: `journalctl -b | grep -i drm`

---

## File Checklist

When switching modes, check these files for marked sections:

- [ ] `hosts/rog-strix/system/boot.nix` - Blacklist and kernel params
- [ ] `hosts/rog-strix/hardware/nvidia.nix` - PRIME configuration
- [ ] `hosts/rog-strix/desktop/plasma.nix` - Optional Wayland settings

Look for sections marked with:
```
═══════════════════════════════════════════════════════════════
MUX SWITCH CONFIGURATION
═══════════════════════════════════════════════════════════════
```

---

## Summary

The key principle: **Your NixOS configuration must match your BIOS MUX switch setting.**

- **Hardware MUX set to dGPU** → Blacklist Intel, disable PRIME
- **Hardware MUX set to Hybrid** → Enable Intel, enable PRIME offload

Always rebuild and reboot after changing the MUX switch and configuration.

