{ lib, ... }: {
  imports = [ ./hardware.nix ];

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.systemd-boot.enable = true;

  hardware.pulseaudio.enable = false;

  networking.hostName = "titan";
  networking.interfaces.enp4s0.useDHCP = lib.mkDefault true;
  networking.networkmanager.enable = true;
  networking.useDHCP = false;
  networking.wg-quick = {
    interfaces.nl13 = {
      autostart = false;
      address = [ "10.2.0.2/32" ];
      dns = [ "10.2.0.1" ];
      listenPort = 51820;
      privateKeyFile = "/private/wireguard/nl13";
      peers = [
        {
          allowedIPs = [ "0.0.0.0/0" "::/0" ];
          endpoint = "190.2.146.180:51820";
          publicKey = "EbxfUNJudEt6J4xL0kHH57eQM+P+OvypYxG4rpzE8iw=";
        }
      ];
    };
  };

  presets.system.i18n.dutch.enable = true;
  presets.system.gaming.enable = true;
  presets.system.cosmic.enable = true;
  presets.system.gnome.enable = false;
  presets.system.nvidia.enable = true;
  presets.system.security.enable = true;

  security.rtkit.enable = true;

  services.pipewire.enable = true;
  services.pipewire.alsa.enable = true;
  services.pipewire.alsa.support32Bit = true;
  services.pipewire.pulse.enable = true;
  services.xserver.displayManager.gdm.wayland = true;

  time.timeZone = "Europe/Amsterdam";

  users.putquo.enable = true;
  users.toil.enable = true;

  system.stateVersion = "23.11";
}
