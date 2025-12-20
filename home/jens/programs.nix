# User programs configuration - git, editors, etc.
{ pkgs, ... }: {
  # Git
  programs.git = {
    enable = true;
    settings = {
      user.name = "refactor-gremlin";
      user.email = "refactor-gremlin@users.noreply.github.com";
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;

      # TODO: GPG signing
      # commit.gpgsign = true;
      # user.signingkey = "YOUR_KEY_ID";
    };
  };

  # Delta for better diffs
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
      light = false;
      side-by-side = true;
      line-numbers = true;
    };
  };

  # TODO: VS Code / Cursor configuration
  # programs.vscode = {
  #   enable = true;
  #   extensions = with pkgs.vscode-extensions; [
  #     # Add extensions here
  #   ];
  # };

  # TODO: Neovim configuration
  # programs.neovim = {
  #   enable = true;
  #   defaultEditor = true;
  # };

  # TODO: Terminal emulator (if not using Konsole)
  # programs.kitty = {
  #   enable = true;
  # };

  # GPG
  programs.gpg.enable = true;

  # SSH
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;  # Avoid deprecated defaults
    # TODO: Add your SSH hosts
    # matchBlocks = {
    #   "*" = {
    #     # Default settings for all hosts
    #   };
    #   "github.com" = {
    #     hostname = "github.com";
    #     user = "git";
    #     identityFile = "~/.ssh/id_ed25519";
    #   };
    # };
  };
}

