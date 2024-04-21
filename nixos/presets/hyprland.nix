{ config, lib', pkgs, ... }: with lib'; templated.preset "hyprland" {
  inherit config;
  whenEnabled = {
    environment.systemPackages = with pkgs; [ grimblast ];

    environment.sessionVariables.__GLX_VENDOR_LIBRARY_NAME = "nvidia";
    environment.sessionVariables.GBM_BACKEND = "nvidia-drm";
    environment.sessionVariables.LIBVA_DRIVER_NAME = "nvidia";
    environment.sessionVariables.NIXOS_OZONE_WL = "1";
    environment.sessionVariables.WLR_NO_HARDWARE_CURSORS = "1";
    environment.sessionVariables.XDG_SESSION_TYPE = "wayland";

    programs.hyprland.enable = true;

    security.pam.services.hyprlock = { };
    security.polkit.enable = true;

    services.gnome.gnome-keyring.enable = true;

    systemd.user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };
}
