{ config, lib, pkgs, inputs, ... }: {
  options.myConfig.desktop.hydenix.enable = lib.mkEnableOption "HyDeNix desktop environment";

  config = lib.mkIf config.myConfig.desktop.hydenix.enable {
    hydenix = {
      enable = true;
      # Hostname, timezone, and locale are managed in other modules
      # and host configurations to avoid infinite recursion.
      
      audio.enable = true;
      boot.enable = false; # Managed in system/boot.nix
      gaming.enable = config.myConfig.profiles.gaming.enable;
      hardware.enable = true;
      network.enable = true;
      nix.enable = false; # Managed in host configurations
      sddm.enable = true;
      system.enable = true;
    };
    
    # Enable SDDM with Wayland
    services.displayManager.sddm.wayland.enable = true;
    
    # Ensure some base packages are available
    environment.systemPackages = with pkgs; [
      kitty
      rofi
      waybar
      swww # Wallpaper daemon
    ];
  };
}
