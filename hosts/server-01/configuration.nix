# Main configuration for server-01 (Headless Server)
# General purpose server with Docker, Tailscale, and essential tools
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    # Hardware configuration (will be auto-generated on first boot if missing)
    ./hardware-configuration.nix
  ];

  # Enable server profile
  myConfig.profiles.server.enable = true;

  # Enable ISO support (flake copy, hardware detection)
  myConfig.system.iso.enable = true;
  myConfig.system.iso.hostName = "server-01";

  # Nixpkgs configuration
  nixpkgs = {
    overlays = [
      inputs.self.overlays.additions
      inputs.self.overlays.modifications
      inputs.self.overlays.stable-packages
      inputs.hydenix.overlays.default
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
      trusted-users = [ "root" "admin" "@wheel" ];
    };
    channel.enable = false;
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  # Hostname
  networking.hostName = "server-01";

  # HyDeNix configuration
  hydenix.hostname = "server-01";
  hydenix.timezone = "Europe/Amsterdam";
  hydenix.locale = "en_GB.UTF-8";

  # Administrator rights
  security.sudo.wheelNeedsPassword = false;

  # User configuration
  users.users.admin = {
    isNormalUser = true;
    description = "Administrator";
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
    ];
  };

  # Enable zsh system-wide (required for user shell)
  programs.zsh.enable = true;
  programs.git.enable = true;
  programs.git.config.safe.directory = "/etc/nixos";

  # SSH server
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true;  # Can be disabled after setting up SSH keys
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = lib.mkForce "26.05";
}

