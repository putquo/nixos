{ config, lib, pkgs, ... }: {
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 8;

  networking.hostName = "delta";
  networking.networkmanager.enable = true;
  networking.useDHCP = lib.mkDefault true;

  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 7d";
  nix.settings.auto-optimise-store = true;

  presets.system.base.enable = true;
  presets.system.gaming.enable = true;
  presets.system.kde.enable = true;
  presets.system.nvidia.enable = true;
  presets.user.formelio.enable = true;
  presets.user.justin.enable = true;

  security.rtkit.enable = true;

  services.fstrim.enable = true;
  services.pipewire.enable = true;
  services.pipewire.alsa.enable = true;
  services.pipewire.alsa.support32Bit = true;
  services.pipewire.pulse.enable = true;

  sound.enable = true;
  system.stateVersion = "23.11";
}
