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
    slurp
    wl-clipboard
    wl-screenrec
    wlr-randr
  ];

  services.displayManager.enable = true;

  services.greetd.enable = true;

  security.rtkit.enable = true;
  services.pipewire.enable = true;
  services.pipewire.alsa.enable = true;
  services.pipewire.alsa.support32Bit = true;
  services.pipewire.pulse.enable = true;
}
