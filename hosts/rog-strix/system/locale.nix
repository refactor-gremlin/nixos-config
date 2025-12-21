# Locale configuration - timezone, keyboard, i18n
{ ... }: {
  # Timezone
  time.timeZone = "Europe/Amsterdam";

  # Locale
  i18n = {
    defaultLocale = "en_GB.UTF-8";
    extraLocaleSettings = {
      LC_TIME = "nl_NL.UTF-8";
      LC_MONETARY = "nl_NL.UTF-8";
    };
  };

  # Console keymap (Dutch)
  console.keyMap = "nl";

  # X11/Wayland keyboard layout - Dutch Mac layout
  services.xserver.xkb = {
    layout = "nl";
    variant = "mac";  # Mac variant for Dutch keyboard
    # Optional: Uncomment for layout switching with Alt+Shift
    # options = "grp:alt_shift_toggle";
  };

  # Networking
  networking.networkmanager.enable = true;
}

