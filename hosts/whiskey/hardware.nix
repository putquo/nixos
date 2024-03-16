{ config, lib, pkgs, modulesPath, ... }: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.extraModulePackages = [ ];
  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" "sdhci_pci" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/8e283c01-0ed1-408b-abe4-b4c67b0363fa";
    fsType = "ext4";
    label = "able";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/7B2C-EC56";
    fsType = "vfat";
    label = "boot";
  };

  hardware.bluetooth.enable = true;
  hardware.cpu.intel.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;

  swapDevices = [ ];
}
