# Audio configuration - Pipewire, ALSA, rtkit
{ ... }: {
  # Disable PulseAudio (replaced by Pipewire)
  services.pulseaudio.enable = false;

  # Enable real-time audio priority
  security.rtkit.enable = true;

  # Pipewire
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;

    # Stable audio configuration with adaptive latency
    # Quantum 128 provides good latency while preventing audio glitches
    # The range (64-2048) allows PipeWire to adapt to system load for stability
    extraConfig.pipewire."92-low-latency" = {
      context.properties = {
        default.clock.rate = 48000;
        default.clock.quantum = 128;
        default.clock.min-quantum = 64;
        default.clock.max-quantum = 2048;
      };
    };
  };
}

