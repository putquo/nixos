{ config, lib, lib', pkgs, ... }: with lib'; templated.preset "desktop" {
  inherit config;
  whenEnabled = {
    environment.systemPackages = with pkgs; [
      curl
      vim
      wget
    ];

    fonts.packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      (nerdfonts.override { fonts = [ "Monaspace" ]; })
    ];

    networking.networkmanager.enable = true;
    networking.useDHCP = lib.mkDefault true;

    nix.extraOptions = ''
      experimental-features = nix-command flakes
      warn-dirty = false
    '';

    nix.gc.automatic = true;
    nix.gc.options = "--delete-older-than 7d";
    nix.settings.auto-optimise-store = true;

    nixpkgs.config.allowUnfree = true;

    programs._1password.enable = true;
    programs._1password-gui.enable = true;
    programs.fish.enable = true;

    security.pam.u2f.enable = true;
    security.pam.u2f.control = "sufficient";
    security.pam.u2f.cue = true;

    services.fstrim.enable = true;

    sound.enable = true;
    time.timeZone = "Europe/Amsterdam";
  };
}
