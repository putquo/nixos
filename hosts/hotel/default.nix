{ config, lib, modulesPath, pkgs, ... }: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
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
  hardware.enableRedistributableFirmware = true;
  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.enable = false;

  networking.networkmanager.enable = true;
  networking.useDHCP = lib.mkDefault true;

  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 7d";
  nix.settings.auto-optimise-store = true;

  presets.system.base.enable = true;
  presets.system.gaming.enable = true;
  presets.system.kde.enable = true;
  presets.system.nvidia.enable = true;
  presets.system.wayland.enable = true;
  presets.user.justin.enable = true;
  presets.user.uniform.enable = true;

  services.fstrim.enable = true;

  sound.enable = true;
  swapDevices = [ ];
  system.stateVersion = "23.11";
}
