{ pkgs, lib, ... }: {
  stylix = {
    enable = true;
    image = pkgs.nixos-artwork.wallpapers.nineish-dark-gray.gnomeFilePath;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
    };

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };
      sansSerif = {
        package = pkgs.inter;
        name = "Inter";
      };
      serif = {
        package = pkgs.inter;
        name = "Inter";
      };
    };

    # Target specific components
    targets = {
      grub.enable = true;
      console.enable = true;
      gtk.enable = lib.mkForce false;
      qt.enable = lib.mkForce false;
    };
  };
}
