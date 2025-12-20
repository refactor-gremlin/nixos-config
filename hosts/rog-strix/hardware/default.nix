# Hardware configuration - GPU, ASUS, audio
{ ... }: {
  imports = [
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

