# KDE Plasma configuration via plasma-manager
# Shared Plasma module for all users
{ pkgs, osConfig, lib, ... }: {
  programs.plasma = {
    enable = true;

    # Workspace appearance
    workspace = {
      clickItemTo = "select";
      cursor = {
        theme = "Bibata-Modern-Classic";
        size = 24;
      };
      iconTheme = "Tela-dark"; # Updated from capture.nix
      splashScreen.theme = "Nordic-darker"; # Updated from capture.nix
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

    # Panel configuration - Two-panel layout with Panel Colorizer
    panels = [
      # 1. Top Panel (Status Bar)
      {
        location = "top";
        height = 32;
        floating = true;
        opacity = "translucent";
        widgets = [
          # Panel Colorizer (first widget recommended)
          "luisbocanegra.panelcolorizer"
          
          # Global Menu (Application Menu) on the left
          "org.kde.plasma.appmenu"
          
          # Spacer to center the clock
          "org.kde.plasma.panelspacer"
          
          # Digital Clock in the center
          {
            digitalClock = {
              calendar.firstDayOfWeek = "monday";
              time.format = "24h";
            };
          }
          
          # Spacer to push tray to the right
          "org.kde.plasma.panelspacer"
          
          # System Tray on the right
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
        ];
      }

      # 2. Bottom Panel (Floating Dock)
      {
        location = "bottom";
        # Thicker panel => visually larger corner radius when floating (more rounded “pill” look)
        height = 58;
        hiding = "autohide";
        floating = true;
        opacity = "translucent";
        widgets = [
          # Panel Colorizer
          "luisbocanegra.panelcolorizer"

          {
            kickoff = {
              sortAlphabetically = true;
              icon = "nix-snowflake-white";
            };
          }
          {
            iconTasks = {
              launchers =
                if osConfig.networking.hostName == "pc-02"
                then [
                  "applications:org.kde.dolphin.desktop"
                  "applications:google-chrome.desktop"
                  "applications:vesktop.desktop"
                  "applications:steam.desktop"
                ]
                else if osConfig.networking.hostName == "rog-strix"
                then [
                  "applications:org.kde.dolphin.desktop"
                  "applications:vesktop.desktop"
                  "applications:cursor.desktop"
                  "applications:google-chrome.desktop"
                  "applications:steam.desktop"
                ]
                else [ ];
            };
          }
        ];
      }
    ];

    # Keyboard shortcuts
    shortcuts = {
      ksmserver = {
        "Lock Session" = ["Meta+Ctrl+L" "Screensaver"];
        "Log Out" = "Ctrl+Alt+Del";
      };
      kwin = {
        "Expose" = "Meta+Tab";
        "Overview" = "Meta+W";
        "Grid View" = "Meta+G";
        "Switch Window Down" = "Meta+J";
        "Switch Window Left" = "Meta+H";
        "Switch Window Right" = "Meta+L";
        "Switch Window Up" = "Meta+K";
        "Window Maximize" = "Meta+Up";
        "Window Minimize" = "Meta+Down";
        "Window Close" = "Meta+Q";
        "Window Quick Tile Left" = "Meta+Left";
        "Window Quick Tile Right" = "Meta+Right";
        "Walk Through Windows" = "Alt+Tab";
        "Window to Next Screen" = "Meta+Shift+Right";
        "Window to Previous Screen" = "Meta+Shift+Left";
      };
      plasmashell = {
        "show-on-mouse-pos" = "Meta+V";
        "activate task manager entry 1" = "Meta+1";
        "activate task manager entry 2" = "Meta+2";
        "activate task manager entry 3" = "Meta+3";
        "activate task manager entry 4" = "Meta+4";
        "activate task manager entry 5" = "Meta+5";
        "next activity" = "Meta+A";
        "previous activity" = "Meta+Shift+A";
      };
      "KDE Keyboard Layout Switcher" = {
        "Switch to Last-Used Keyboard Layout" = "Meta+Alt+L";
        "Switch to Next Keyboard Layout" = "Meta+Alt+K";
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

    # Power management
    powerdevil = {
      AC = {
        powerButtonAction = "lockScreen";
        autoSuspend.action = "nothing";
        turnOffDisplay.idleTimeout = 3600;
        dimDisplay = {
          enable = true;
          idleTimeout = 3300;
        };
      };
      battery = {
        powerButtonAction = "sleep";
        whenSleepingEnter = "standbyThenHibernate";
        autoSuspend = {
          action = "sleep";
          idleTimeout = 900;
        };
        turnOffDisplay.idleTimeout = 300;
        dimDisplay = {
          enable = true;
          idleTimeout = 120;
        };
      };
      lowBattery = {
        powerButtonAction = "hibernate";
        whenLaptopLidClosed = "hibernate";
      };
    };

    # KWin (window manager)
    kwin = {
      edgeBarrier = 0;
      cornerBarrier = false;
      effects = {
        shakeCursor.enable = true;
        blur.enable = true;
        translucency.enable = true;
        wobblyWindows.enable = true;
      };
    };

    # Screen locker
    kscreenlocker = {
      lockOnResume = true;
      timeout = 5;
    };

    # Low-level config tweaks
    configFile = {
      # Disable Baloo file indexer
      baloofilerc."Basic Settings"."Indexing-Enabled" = false;
      
      # General settings
      kdeglobals.General.widgetStyle = "kvantum";
      kdeglobals.KDE.SingleClick = false;

      # 4 virtual desktops
      kwinrc.Desktops.Number = {
        value = 4;
        immutable = true;
      };
      kwinrc.Desktops.Rows = 2;

      # Window decoration buttons
      kwinrc."org.kde.kdecoration2".ButtonsOnLeft = "";
      kwinrc."org.kde.kdecoration2".ButtonsOnRight = "IAX";
      kwinrc."org.kde.kdecoration2".theme = "__aurorae__svg__Nordic";

      # Mouse Settings
      "kcminputrc"."Libinput/1133/16511/Logitech G502".PointerAccelerationProfile = 1;
      "kcminputrc"."Libinput/12625/16405/ROYUAN Gaming Keyboard Mouse".PointerAccelerationProfile = 1;

      # Tiling
      kwinrc.Tiling.padding = 4;

      # Gaming optimizations
      kwinrc.Compositing.UnredirectFullscreen = true;
      kwinrc.Compositing.VSync = "none";
      kwinrc.Compositing.AllowTearing = true;
      kwinrc.Compositing.SuspendCompositingForFullscreen = true;
      kwinrc.Compositing.WindowsBlockCompositing = true;
      kwinrc.Compositing.GLPreferBufferSwap = "a";
      kwinrc.Compositing.GLTextureFilter = 0;

      # KWin Blur effect tuning
      kwinrc."Effect-Blur"."BlurStrength" = 1;
      kwinrc."Effect-Blur"."NoiseStrength" = 0;
      kwinrc.blur.blurRadius = 25;
      kwinrc.blur.blurStrength = 3;

      # Theme settings
      plasmarc."PlasmaTheme"."blurEnabled" = true;
      plasmarc."PlasmaTheme"."transparencyEnabled" = true;
      plasmarc."Theme"."name" = "Nordic-darker";

      # Panel Colorizer settings (global defaults)
      "panelcolorizerrc"."General"."bgOpacity" = 0; # Fully transparent base
      "panelcolorizerrc"."General"."bgBlur" = true;
      "panelcolorizerrc"."General"."bgRadius" = 24; # More rounded
      "panelcolorizerrc"."General"."bgMargin" = 8;  # Margin for floating effect
      "panelcolorizerrc"."General"."bgEnabled" = true;
      "panelcolorizerrc"."General"."bgCustomColor" = false;
    };
  };

  # Disable Stylix and HM GTK management to avoid conflicts with KDE Plasma
  stylix.targets.gtk.enable = lib.mkForce false;
  stylix.targets.qt.enable = lib.mkForce false;
  stylix.targets.kde.enable = lib.mkForce false;
  gtk.enable = lib.mkForce false;

  # Enable Kvantum
  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style.name = "kvantum";
  };
}
