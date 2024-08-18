{ ... }@_haumeaArgs:
{ config, pkgs, ... }@_nixosModuleArgs: {
  environment.systemPackages = with pkgs; [
    grimblast
    satty
    wbg
  ];

  programs.hyprland.enable = true;

  security.pam.services.hyprlock = { };
  security.polkit.enable = true;

  services.gnome.gnome-keyring.enable = true;

  services.greetd.settings = {
    default_session =
      let
        sessions = "${config.services.displayManager.sessionData.desktops}/share/wayland-sessions";
        tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
      in
      {
        command = "${tuigreet} --user-menu --time --remember --remember-user-session --sessions ${sessions}";
      };
  };

  # https://github.com/sjcobb2022/nixos-config/blob/68213c638fcfa734723e1fe8a50654b845680e5f/hosts/common/optional/greetd.nix
  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal";
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };

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
