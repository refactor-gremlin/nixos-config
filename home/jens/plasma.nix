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
        family = "Noto Sans";
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
            iconTasks = {
              launchers = [
                "applications:org.kde.dolphin.desktop"
                "applications:org.kde.konsole.desktop"
                "applications:firefox.desktop"
              ];
            };
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
    };

    # Power management (important for gaming laptop!)
    powerdevil = {
      AC = {
        powerButtonAction = "lockScreen";
        autoSuspend.action = "nothing"; # Don't suspend when gaming
        turnOffDisplay.idleTimeout = 600; # 10 minutes
        dimDisplay = {
          enable = true;
          idleTimeout = 300; # 5 minutes
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

      # Window decoration buttons (macOS style - close/min/max on left)
      kwinrc."org.kde.kdecoration2".ButtonsOnLeft = "XIA";
      kwinrc."org.kde.kdecoration2".ButtonsOnRight = "";
    };
  };
}

