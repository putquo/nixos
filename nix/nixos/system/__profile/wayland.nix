{ ... }@_haumeaArgs:
{ config, pkgs, ... }@_nixosModuleArgs: {
  environment.sessionVariables.__GLX_VENDOR_LIBRARY_NAME = "nvidia";
  environment.sessionVariables.GBM_BACKEND = "nvidia-drm";
  environment.sessionVariables.LIBVA_DRIVER_NAME = "nvidia";
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.sessionVariables.WLR_NO_HARDWARE_CURSORS = "1";
  environment.sessionVariables.XDG_SESSION_TYPE = "wayland";

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
}
