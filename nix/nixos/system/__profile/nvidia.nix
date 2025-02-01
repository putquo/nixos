{ ... }@_haumeaArgs:
{ config, ... }@_nixosModuleArgs: {
  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.nvidiaSettings = true;
  hardware.nvidia.open = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.beta;
  hardware.nvidia.powerManagement.enable = true;

  services.xserver.videoDrivers = [ "nvidia" ];
}
