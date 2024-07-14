{ name, super, ... }@_haumeaArgs:
{ pkgs, ... }@_nixosModuleArgs: {
  imports = [
    super.hardware.notDetected
    super.platform."x86_64-linux"
  ];

  boot.extraModulePackages = [ ];
  boot.initrd.availableKernelModules = [
    "ahci"
    "nvme"
    "sd_mod"
    "usbhid"
    "usb_storage"
    "xhci_pci"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 8;

  fileSystems."/".device = "/dev/disk/by-label/able";
  fileSystems."/".fsType = "ext4";
  fileSystems."/boot".device = "/dev/disk/by-label/BOOT";
  fileSystems."/boot".fsType = "vfat";
  fileSystems."/mnt/baker".device = "/dev/disk/by-label/baker";
  fileSystems."/mnt/baker".fsType = "ext4";
  fileSystems."/mnt/easy".device = "/dev/disk/by-label/easy";
  fileSystems."/mnt/easy".fsType = "ext4";

  hardware.bluetooth.enable = true;
  hardware.cpu.intel.updateMicrocode = true;
  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;
  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.enable = false;

  networking.hostName = name;

  swapDevices = [ ];
  system.stateVersion = "23.11";
}
