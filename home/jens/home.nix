# Home Manager configuration for jens
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
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
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      nerd-fonts.jetbrains-mono

      # KDE extras
      kdePackages.kde-gtk-config
      kdePackages.breeze-gtk

      # TODO: Add your user packages here
      # Browsers
      # google-chrome
      # firefox

      # Communication
      # discord
      # slack

      # Media
      # spotify
      # vlc

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
  home.stateVersion = "24.05";
}

