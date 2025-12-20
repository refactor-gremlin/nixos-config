# Shell configuration - Zsh, Oh-My-Zsh, Starship
{ pkgs, ... }: {
  # Zsh
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # Oh-My-Zsh
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";  # TODO: Choose your theme
      plugins = [
        "git"
        "docker"
        "kubectl"
        "direnv"
        # TODO: Add more plugins
      ];
    };

    # Shell aliases
    shellAliases = {
      # Nix
      rebuild = "sudo nixos-rebuild switch --flake ~/nix-config#rog-strix";
      update = "nix flake update ~/nix-config";

      # General
      ll = "ls -la";
      ".." = "cd ..";
      "..." = "cd ../..";

      # Git shortcuts
      gs = "git status";
      gd = "git diff";
      gc = "git commit";
      gp = "git push";
      gl = "git pull";

      # TODO: Add your aliases
    };

    # Extra configuration
    initExtra = ''
      # TODO: Add custom shell initialization here
    '';
  };

  # TODO: Alternative to Oh-My-Zsh - Starship prompt
  # programs.starship = {
  #   enable = true;
  #   settings = {
  #     # See https://starship.rs/config/
  #   };
  # };

  # Direnv integration (loads .envrc files automatically)
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
}

