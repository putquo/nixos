{ config, lib, pkgs, ... }: {
  options = {
    presets.system.wayland.enable = lib.mkEnableOption {
      default = false;
      description = "Enable wayland system preset";
    };
  };

  config = lib.mkIf config.presets.system.wayland.enable {
    environment.sessionVariables.NIXOS_OZONE_WL = "1";
    security.rtkit.enable = true;
    services.pipewire.enable = true;
    services.pipewire.alsa.enable = true;
    services.pipewire.alsa.support32Bit = true;
    services.pipewire.pulse.enable = true;
  };
}
