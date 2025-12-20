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

  # Console keymap
  console.keyMap = "us";

  # X11/Wayland keyboard layout
  services.xserver.xkb = {
    layout = "us";
    variant = "intl";
    # TODO: Uncomment for layout switching with Alt+Shift
    # options = "grp:alt_shift_toggle";
  };

  # Networking
  networking.networkmanager.enable = true;
}

