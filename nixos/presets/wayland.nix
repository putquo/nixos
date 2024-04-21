{ config, lib', pkgs, ... }: with lib'; templated.preset "wayland" {
  inherit config;
  whenEnabled = {
    environment.sessionVariables.NIXOS_OZONE_WL = "1";
    environment.systemPackages = with pkgs; [
      grim
      mpv
      satty
      slurp
      wbg
      wl-clipboard
      wl-screenrec
      wlr-randr
    ];

    services.displayManager.enable = true;

    services.greetd.enable = true;
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

    security.rtkit.enable = true;
    services.pipewire.enable = true;
    services.pipewire.alsa.enable = true;
    services.pipewire.alsa.support32Bit = true;
    services.pipewire.pulse.enable = true;

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
  };
}
