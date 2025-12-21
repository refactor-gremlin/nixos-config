# Home Manager configuration for jens
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  # Access flake inputs for packages
  system = "x86_64-linux";
in {
  imports = [
    ./shell.nix
    ./programs.nix
    ./plasma.nix
  ];

  # Home Manager settings
  home = {
    username = "jens";
    homeDirectory = "/home/jens";

    # Packages to install for this user
    packages = with pkgs; [
      # Theming (required for plasma.nix)
      bibata-cursors
      papirus-icon-theme

      # Fonts
      inter
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      nerd-fonts.jetbrains-mono

      # KDE extras
      kdePackages.kde-gtk-config
      kdePackages.breeze-gtk

      # TODO: Add your user packages here
      # Browsers
      google-chrome

      # Communication
      discord
      teams-for-linux

      # Media
      ytmdesktop  # YouTube Music Desktop
      # spotify
      vlc

      # Development tools
      # Node.js 24 (includes npm, so no need for separate nodePackages.npm)
      nodejs_24
      # Note: npm is included with nodejs_24, so nodePackages.npm is not needed
      
      # Factory AI droid CLI (via nix-ai-tools flake)
      inputs.nix-ai-tools.packages.${system}.droid
      
      # GitHub Copilot CLI (available in nixpkgs)
      github-copilot-cli
      
      # Codex CLI (via flake)
      # Access via: nix run github:sadjow/codex-nix#codex
      
      # Utilities
      # bitwarden
      # flameshot
    ];
  };

  # Enable home-manager itself
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "26.05";
}

