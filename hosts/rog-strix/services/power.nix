# Power configuration - suspend, hibernate, lid actions
{ ... }: {
  # Logind settings for lid/power button
  services.logind = {
    # Lid close behavior
    lidSwitch = "suspend";                    # On battery
    lidSwitchExternalPower = "ignore";        # When plugged in
    lidSwitchDocked = "ignore";               # When docked

    # Power button
    powerKey = "poweroff";
    powerKeyLongPress = "poweroff";

    # Idle action (optional)
    # extraConfig = ''
    #   IdleAction=suspend
    #   IdleActionSec=30min
    # '';
  };

  # Enable suspend and hibernate
  # Note: Hibernate requires resume device in boot.nix

  # Systemd sleep settings
  systemd.sleep.extraConfig = ''
    AllowSuspend=yes
    AllowHibernation=yes
    AllowSuspendThenHibernate=yes
    AllowHybridSleep=yes
  '';

  # TODO: Suspend-then-hibernate (suspend for X time, then hibernate)
  # systemd.sleep.extraConfig = ''
  #   HibernateDelaySec=2h
  # '';

  # Power profiles daemon is enabled in asus.nix
}

