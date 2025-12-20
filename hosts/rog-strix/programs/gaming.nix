# Gaming configuration - Steam, Proton, GameMode
{ pkgs, ... }: {
  # Steam
  programs.steam = {
    enable = true;
    # Open ports for Steam Remote Play
    remotePlay.openFirewall = true;
    # Open ports for Steam Local Network Game Transfers
    localNetworkGameTransfers.openFirewall = true;
    # Use Gamescope compositor for Steam
    gamescopeSession.enable = true;
  };

  # GameMode - game performance optimizations
  programs.gamemode = {
    enable = true;
    enableRenice = true;
    settings = {
      general = {
        renice = 10;
      };
      gpu = {
        apply_gpu_optimisations = "accept-responsibility";
        gpu_device = 0;
      };
    };
  };

  # TODO: Additional gaming packages
  # environment.systemPackages = with pkgs; [
  #   # Proton/Wine
  #   protonup-qt        # Proton version manager
  #   wine               # Wine for non-Steam games
  #   winetricks         # Wine helper scripts
  #
  #   # Performance overlay
  #   mangohud           # FPS/performance overlay
  #   goverlay           # MangoHud GUI configurator
  #
  #   # Gamescope
  #   gamescope          # Micro-compositor for games
  #
  #   # Controllers
  #   antimicrox         # Gamepad to keyboard mapping
  # ];

  # TODO: Enable 32-bit libraries for Wine/Proton (already enabled via hardware.graphics.enable32Bit)
}

