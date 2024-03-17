{ config, lib, modulesPath, pkgs, ... }: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
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

  networking.networkmanager.enable = true;
  networking.useDHCP = lib.mkDefault true;
  
  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 7d";
  nix.settings.auto-optimise-store = true;
  
  presets.system.base.enable = true;
  presets.system.kde.enable = true;
  presets.user.uniform.enable = true;
  
  services.fprintd.enable = true;
  services.fprintd.tod.enable = true;
  services.fprintd.tod.driver = pkgs.libfprint-2-tod1-vfs0090;
  services.fstrim.enable = true;

  sound.enable = true;
  swapDevices = [ ];
  system.stateVersion = "23.11";
}
