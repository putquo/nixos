{ name, super, ... }@_haumeaArgs:
{ pkgs, ... }@_nixosModuleArgs: {
  imports = [
    super.hardware.notDetected
    super.platform."x86_64-linux"
  ];

  boot.initrd.availableKernelModules = [
    "ahci"
    "nvme"
    "usbhid"
    "usb_storage"
    "sd_mod"
    "xhci_pci"
  ];
  boot.extraModulePackages = [ ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.systemd-boot.enable = true;

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/d03378bc-d9e9-4138-a999-d24f570a3611";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/BAE4-276C";
      fsType = "vfat";
    };

  fileSystems."/mnt/kratos" =
    {
      device = "/dev/disk/by-label/kratos";
      fsType = "ext4";
    };

  hardware.bluetooth.enable = true;
  hardware.cpu.amd.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;
  hardware.graphics.enable = true;

  networking.hostName = name;

  swapDevices = [ ];
  system.stateVersion = "23.11";
}
