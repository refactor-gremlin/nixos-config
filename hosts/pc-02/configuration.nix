# Main configuration for pc-02 (Lisa's Desktop)
# AMD CPU + NVIDIA GPU desktop
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    # Hardware configuration (generate on target machine)
    ./hardware-configuration.nix
  ];

  # Enable profiles and options
  myConfig.profiles.workstation.enable = true;
  myConfig.services.tailscale.enable = true;
  myConfig.services.tailscale.operator = "lisa";  # Allow ktailctl GUI to work
  myConfig.secrets.sshKeyUser = "lisa";  # Deploy SSH key to this user

  # Enable ISO support (flake copy, hardware detection)
  myConfig.system.iso.enable = true;
  myConfig.system.iso.hostName = "pc-02";

  # Hardware configuration
  myConfig.hardware.nvidia.enable = true;
  myConfig.hardware.nvidia.isLaptop = false;
  myConfig.hardware.nvidia.stabilityTweaks.enable = true;
  myConfig.hardware.cpu.amd.enable = true;

  # Nixpkgs configuration
  nixpkgs = {
    overlays = [
      inputs.self.overlays.additions
      inputs.self.overlays.modifications
      inputs.self.overlays.stable-packages
      inputs.chaotic.overlays.default
      inputs.hydenix.overlays.default
      inputs.self.overlays.fix-hyq
    ];
    config = {
      allowUnfree = true;
    };
  };

  # Nix settings
  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      experimental-features = ["nix-command" "flakes"];
      flake-registry = "";
      nix-path = config.nix.nixPath;
      download-buffer-size = 67108864; # 64MB
      trusted-users = [ "root" "lisa" "@wheel" ];
    };
    channel.enable = false;
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  # Hostname
  networking.hostName = "pc-02";

  # HyDeNix configuration
  hydenix.hostname = "pc-02";
  hydenix.timezone = "Europe/Amsterdam";
  hydenix.locale = "en_GB.UTF-8";

  # Administrator rights
  security.sudo.wheelNeedsPassword = false;

  # User configuration
  users.users.lisa = {
    isNormalUser = true;
    description = "Lisa";
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "audio"
      "docker"
    ];
  };

  # Enable zsh system-wide (required for user shell)
  programs.zsh.enable = true;
  programs.git.enable = true;
  programs.git.config.safe.directory = "/etc/nixos";

  # Flatpak for Sober (Roblox launcher)
  services.flatpak.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = lib.mkForce "26.05";
}

