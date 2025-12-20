# Development configuration - Docker, languages, tools
{ pkgs, ... }: {
  # Docker
  virtualisation.docker = {
    enable = true;
    enableNvidia = true;  # NVIDIA container runtime
    # TODO: Rootless mode (more secure, but some compatibility issues)
    # rootless = {
    #   enable = true;
    #   setSocketVariable = true;
    # };
  };

  # GPG agent for signing commits
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Direnv for automatic environment loading
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Git (basic system-wide, detailed config in home-manager)
  programs.git.enable = true;

  # TODO: Development packages
  # environment.systemPackages = with pkgs; [
  #   # Editors
  #   # code-cursor  # Cursor IDE (needs overlay or FHS)
  #
  #   # Nix tools
  #   nix-index    # nix-locate command
  #   comma        # Run programs without installing: , program
  #
  #   # Languages (prefer per-project with devShells/direnv)
  #   # nodejs_22
  #   # go
  #   # rustup
  #   # python3
  #   # dotnet-sdk_8
  # ];

  # TODO: nix-index for command-not-found
  # programs.nix-index = {
  #   enable = true;
  #   enableZshIntegration = true;
  # };
}

