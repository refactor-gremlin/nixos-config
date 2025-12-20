# Audio configuration - Pipewire, ALSA, rtkit
{ ... }: {
  # Disable PulseAudio (replaced by Pipewire)
  hardware.pulseaudio.enable = false;

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

    # TODO: Low-latency configuration for gaming
    # extraConfig.pipewire."92-low-latency" = {
    #   context.properties = {
    #     default.clock.rate = 48000;
    #     default.clock.quantum = 32;
    #     default.clock.min-quantum = 32;
    #     default.clock.max-quantum = 32;
    #   };
    # };
  };
}

