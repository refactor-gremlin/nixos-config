# KDE Plasma configuration via plasma-manager
{ pkgs, ... }: {
  programs.plasma = {
    enable = true;

    # Workspace appearance
    workspace = {
      clickItemTo = "select"; # Single-click to select (double-click to open)
      lookAndFeel = "org.kde.breezedark.desktop";
      cursor = {
        theme = "Bibata-Modern-Classic";
        size = 24;
      };
      iconTheme = "Papirus-Dark";
      # TODO: Uncomment to set wallpaper
      # wallpaper = "${pkgs.kdePackages.plasma-workspace-wallpapers}/share/wallpapers/Mountain/contents/images/5120x2880.png";
    };

    # Fonts
    fonts = {
      general = {
        family = "Inter";
        pointSize = 10;
      };
      fixedWidth = {
        family = "JetBrainsMono Nerd Font";
        pointSize = 10;
      };
    };

    # Panel configuration - Modern bottom panel
    panels = [
      {
        location = "bottom";
        height = 44;
        hiding = "none";
        floating = true;
        widgets = [
          {
            kickoff = {
              sortAlphabetically = true;
              icon = "nix-snowflake-white";
            };
          }
          {
            iconTasks = { };
          }
          "org.kde.plasma.marginsseparator"
          {
            systemTray.items = {
              shown = [
                "org.kde.plasma.battery"
                "org.kde.plasma.bluetooth"
                "org.kde.plasma.networkmanagement"
                "org.kde.plasma.volume"
              ];
            };
          }
          {
            digitalClock = {
              calendar.firstDayOfWeek = "monday";
              time.format = "24h";
            };
          }
          "org.kde.plasma.showdesktop"
        ];
      }
    ];

    # Keyboard shortcuts
    shortcuts = {
      ksmserver = {
        "Lock Session" = ["Meta+Ctrl+L" "Screensaver"];
      };
      kwin = {
        "Expose" = "Meta+Tab";
        "Overview" = "Meta+W";
        "Switch Window Down" = "Meta+J";
        "Switch Window Left" = "Meta+H";
        "Switch Window Right" = "Meta+L";
        "Switch Window Up" = "Meta+K";
        "Window Maximize" = "Meta+Up";
        "Window Minimize" = "Meta+Down";
        "Window Close" = "Meta+Q";
      };
      plasmashell = {
        "show-on-mouse-pos" = "Meta+V"; # Clipboard on Meta+V
      };
    };

    # Hotkeys for launching apps
    hotkeys.commands = {
      "launch-konsole" = {
        name = "Launch Konsole";
        key = "Meta+Return";
        command = "konsole";
      };
      "launch-dolphin" = {
        name = "Launch Dolphin";
        key = "Meta+E";
        command = "dolphin";
      };
      "launch-rofi" = {
        name = "Launch Rofi";
        key = "Meta+Space";
        command = "rofi -show drun";
      };
    };

    # Power management (important for gaming laptop!)
    powerdevil = {
      AC = {
        powerButtonAction = "lockScreen";
        autoSuspend.action = "nothing"; # Never suspend when plugged in
        turnOffDisplay.idleTimeout = 3600; # 1 hour (screen off when plugged in)
        dimDisplay = {
          enable = true;
          idleTimeout = 3300; # 55 minutes (dim before screen turns off)
        };
      };
      battery = {
        powerButtonAction = "sleep";
        whenSleepingEnter = "standbyThenHibernate";
        autoSuspend = {
          action = "sleep";
          idleTimeout = 900; # 15 minutes
        };
        turnOffDisplay.idleTimeout = 300; # 5 minutes
        dimDisplay = {
          enable = true;
          idleTimeout = 120; # 2 minutes
        };
      };
      lowBattery = {
        powerButtonAction = "hibernate";
        whenLaptopLidClosed = "hibernate";
      };
    };

    # KWin (window manager)
    kwin = {
      edgeBarrier = 0; # Disable edge barriers
      cornerBarrier = false;

      # Enable some nice effects
      effects = {
        shakeCursor.enable = true;
        blur.enable = false;  # Disable blur for better gaming performance
      };
    };

    # Screen locker
    kscreenlocker = {
      lockOnResume = true;
      timeout = 5; # Lock after 5 minutes
    };

    # Low-level config tweaks
    configFile = {
      # Disable Baloo file indexer (saves battery, reduces disk I/O)
      baloofilerc."Basic Settings"."Indexing-Enabled" = false;

      # 4 virtual desktops
      kwinrc.Desktops.Number = {
        value = 4;
        immutable = true;
      };
      kwinrc.Desktops.Rows = 2;

      # Window decoration buttons (Windows style - min/max/close on right)
      kwinrc."org.kde.kdecoration2".ButtonsOnLeft = "";
      kwinrc."org.kde.kdecoration2".ButtonsOnRight = "IAX";

      # Gaming optimizations - Fix frame pacing and input lag
      # Unredirect fullscreen windows (bypasses compositor for fullscreen apps)
      kwinrc.Compositing.UnredirectFullscreen = true;
      # VSync mode: "none" (off), "automatic" (adaptive), "full" (always on)
      # "none" is best for gaming - eliminates input lag from compositor VSync
      kwinrc.Compositing.VSync = "none";
      # Allow tearing for fullscreen windows (reduces input lag, requires VSync=none)
      kwinrc.Compositing.AllowTearing = true;
      # Disable compositor on fullscreen (CRITICAL for gaming - bypasses compositor entirely)
      kwinrc.Compositing.SuspendCompositingForFullscreen = true;
      # Allow applications to block compositing (games can request compositor disable)
      kwinrc.Compositing.WindowsBlockCompositing = true;
      # Use OpenGL 2.0 backend (more stable, less overhead than 3.1)
      kwinrc.Compositing.GLPreferBufferSwap = "a";
      # Disable texture filtering for better performance
      kwinrc.Compositing.GLTextureFilter = 0;
    };
  };
}

