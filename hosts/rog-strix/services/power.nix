# Power configuration - suspend, hibernate, lid actions
{ ... }: {
  # Logind settings for lid/power button
  services.logind.settings = {
    Login = {
      # Lid close behavior
      HandleLidSwitch = "suspend";              # On battery
      HandleLidSwitchExternalPower = "ignore";  # When plugged in
      HandleLidSwitchDocked = "ignore";         # When docked

      # Power button
      HandlePowerKey = "poweroff";
      HandlePowerKeyLongPress = "poweroff";

      # Idle action (optional)
      # IdleAction = "suspend";
      # IdleActionSec = "30min";
    };
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

