{ config, lib, pkgs, ... }: {
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 4;
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
  system.stateVersion = "23.11";
}
