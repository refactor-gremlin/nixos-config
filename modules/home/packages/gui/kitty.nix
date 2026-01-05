{ pkgs, ... }: {
  home.packages = with pkgs; [
    # Fonts moved to plasma.nix
  ];

  programs.kitty = {
    enable = true;
    settings = {
      font_size = 10;
      scrollback_lines = 10000;
      enable_audio_bell = false;
      update_check_interval = 0;
    };
    extraConfig = ''
      # font_family config - using the virtual GlobalUserFont
      # which is toggled via script instantly
      font_family      GlobalUserFont
    '';
  };
}
