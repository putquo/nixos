{ config, lib, pkgs, ... }: with lib; {
  options = {
    presets.system.automation.enable = mkEnableOption "the automation system preset";
  };

  config = mkIf config.presets.system.automation.enable {
    environment.systemPackages = with pkgs; [
      spice
      spice-gtk
      spice-protocol
      virt-viewer
    ];

    networking.useDHCP = mkForce false;
    networking.bridges.br0.interfaces = [ "enp4s0" ];
    networking.interfaces.br0 = {
      useDHCP = true;
    };
    networking.firewall.allowedTCPPorts = [ 5900 ];

    virtualisation.libvirtd = with pkgs; {
      enable = true;
      qemu = {
        package = qemu_kvm;
        swtpm.enable = true;
        ovmf.enable = true;
        ovmf.packages = [ 
          (OVMF.override {
            secureBoot = false;
            tpmSupport = true;
          }).fd
        ];
      };
    };

    programs.dconf.enable = true;
    programs.virt-manager.enable = true;
  };
}
