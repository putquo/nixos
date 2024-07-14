{ ... }@_haumeaArgs:
{ pkgs, ... }@_nixosModuleArgs: {
  environment.systemPackages = with pkgs; [ grimblast ];

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
}
