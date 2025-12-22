# Hardware configuration - GPU, ASUS, audio
{ ... }: {
  imports = [
    ./gpu-mode.nix    # GPU mode selector (dedicated/hybrid/integrated)
    ./nvidia.nix
    ./asus.nix
    ./audio.nix
  ];

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
}

