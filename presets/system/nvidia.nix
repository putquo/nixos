{ config, lib, pkgs, ... }: {
  options = {
    presets.system.nvidia.enable = lib.mkEnableOption {
      default = false;
      description = "Enable Nvidia system preset";
    };
  };

  config = lib.mkIf config.presets.system.nvidia.enable {
    boot.kernelParams = [ "nvidia.NVreg_PreserveVideoMemoryAllocations=1" ];
    hardware.nvidia.modesetting.enable = true;
    hardware.nvidia.nvidiaSettings = true;
    hardware.nvidia.open = false;
    hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.beta;
    hardware.nvidia.powerManagement.enable = true;
    services.xserver.videoDrivers = [ "nvidia" ];
  };
}
