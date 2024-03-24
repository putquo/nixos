{ config, lib, lib', pkgs, ... }: with lib'; templated.preset "kde" {
  inherit config;
  whenEnabled = {
    services.desktopManager.plasma6.enable = true;
    services.xserver.enable = true;
    services.xserver.displayManager.sddm.enable = true;
    services.xserver.displayManager.sddm.wayland.enable = config.presets.wayland.enable;
  };
}
