# Stability tweaks for NVIDIA GPUs experiencing "fallen off the bus" errors
# Specific to pc-02 to avoid affecting other hosts
{ config, lib, pkgs, ... }: {
  boot.kernelParams = [
    # Disable GSP firmware which can cause instability on some 30-series cards
    "nvidia.NVreg_EnableGpuFirmware=0"
    # Prevent the GPU from dropping to too low of a power state
    # This forces the GPU to maintain higher clock speeds/voltages even at idle
    "nvidia.NVreg_RegistryDwords=PowerMizerEnable=0x1;PerfLevelSrc=0x2222;PowerMizerLevel=0x3;PowerMizerDefault=0x3;PowerMizerDefaultAC=0x3"
  ];
}
