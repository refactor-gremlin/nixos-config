{ config, pkgs, inputs, lib, ... }: {
  imports = [
    inputs.hydenix.homeModules.default
  ];

  hydenix.hm = {
    enable = true;
    hyde.enable = true;
    hyprland.enable = true;
    hyprland.extraConfig = ''
      exec-once = ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1
      exec-once = gnome-keyring-daemon --start --components=secrets
    '';
    waybar.enable = true;
    rofi.enable = true;
    notifications.enable = true;
    lockscreen.enable = true;
    theme = {
      enable = true;
      active = "Pixel Dream";
      themes = [
        "Pixel Dream"
        "Catppuccin Mocha"
        "Tokyo Night"
        "Gruvbox Retro"
      ];
    };
    # Leverage HyDeNix managed applications
    firefox.enable = true;
    dolphin.enable = true;
    spotify.enable = true;

    git.enable = false; # Managed in programs.nix and home/user.nix

    editors = {
      enable = true;
      neovim = true;
      vscode = {
        enable = true;
        wallbash = true;
      };
      default = "code";
    };
    
    # Terminal configuration
    terminals.kitty = {
      enable = true;
      configText = ''
        font_size 12.0
        confirm_os_window_close 0
        background_opacity 0.8
        shell_integration disabled
        term xterm-256color
      '';
    };

    # Shell configuration
    shell = {
      enable = true;
      zsh = {
        enable = true;
        plugins = [ "sudo" "git" "docker" ];
      };
      starship.enable = true;
    };
  };

  # Standard home-manager options
  home.packages = with pkgs; [
    grim # screenshot tool
    slurp # region selection for screenshots
    wl-clipboard # clipboard manager
    nwg-displays # output management for wlroots
  ];
}
