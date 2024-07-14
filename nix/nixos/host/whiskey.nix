{ name, super, ... }@_haumeaArgs:
{ pkgs, ... }@_nixosModuleArgs: {
  imports = [
    super.hardware.notDetected
    super.platform."x86_64-linux"
  ];

  boot.extraModulePackages = [ ];
  boot.initrd.availableKernelModules = [
    "nvme"
    "sd_mod"
    "sdhci_pci"
    "thunderbolt"
    "usb_storage"
    "xhci_pci"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 4;

  fileSystems."/".device = "/dev/disk/by-label/able";
  fileSystems."/".fsType = "ext4";
  fileSystems."/boot".device = "/dev/disk/by-label/BOOT";
  fileSystems."/boot".fsType = "vfat";

  hardware.bluetooth.enable = true;
  hardware.cpu.intel.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;

  networking.hostName = name;

  services.fprintd.enable = true;
  services.fprintd.tod.enable = true;
  services.fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix;

  swapDevices = [ ];
  system.stateVersion = "23.11";
}
