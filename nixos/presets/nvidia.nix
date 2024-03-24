{ config, lib, lib', pkgs, ... }: with lib'; templated.preset "nvidia" {
  inherit config;
  whenEnabled = {
    boot.kernelParams = [ "nvidia.NVreg_PreserveVideoMemoryAllocations=1" ];
    hardware.nvidia.modesetting.enable = true;
    hardware.nvidia.nvidiaSettings = true;
    hardware.nvidia.open = false;
    hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.beta;
    hardware.nvidia.powerManagement.enable = true;
    services.xserver.videoDrivers = [ "nvidia" ];
  };
}
