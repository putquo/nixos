{ config, lib, pkgs, modulesPath, ... }: {
  imports = [ 
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.extraModulePackages = [ ];
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/afe83042-6519-430d-908c-dd2afe7fa464";
    fsType = "ext4";
    label = "talos";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/05F5-64B5";
    fsType = "vfat";
    label = "boot";
  };

  fileSystems."/mnt/argo" = {
    device = "/dev/disk/by-uuid/62122048-de14-403f-8640-fd2572ca8ec2";
    fsType = "ext4";
    label = "argo";
  };
 
  fileSystems."/mnt/ichor" = {
    device = "/dev/disk/by-uuid/260a30f2-04f0-4b55-8fc4-4fcd966796d2";
    fsType = "ext4";
    label = "ichor";
  };

  hardware.bluetooth.enable = true;
  hardware.cpu.intel.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;
  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.enable = false;

  swapDevices = [ ];
}
