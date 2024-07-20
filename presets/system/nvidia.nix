{ config, lib, ... }: with lib; {
  options = {
    presets.system.nvidia.enable = mkEnableOption "the Nvidia system preset";
  };

  config = mkIf config.presets.system.nvidia.enable {
    hardware.graphics.enable = true;

    hardware.nvidia = {
      modesetting.enable = true;

      nvidiaSettings = true;

      open = false;

      package = config.boot.kernelPackages.nvidiaPackages.beta;

      powerManagement.enable = false;
      powerManagement.finegrained = false;
    };

    services.xserver.videoDrivers = [ "nvidia" ];
  };
}
