{ config, lib, pkgs, ... }: {
  options = {
    presets.system.kde.enable = lib.mkEnableOption {
      default = false;
      description = "Enable KDE system preset";
    };
  };

  config = lib.mkIf config.presets.system.kde.enable {
    services.xserver.enable = true;
    services.xserver.desktopManager.plasma6.enable = true;
    services.xserver.displayManager.sddm.enable = true;
    services.xserver.displayManager.sddm.wayland.enable = true;
  };
}
