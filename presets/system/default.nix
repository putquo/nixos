{ config, lib, pkgs, ... }: with lib; let
  wsl = config.wsl.enable;
in
{
  imports = [
    ./automation.nix
    ./gaming.nix
    ./gnome.nix
    ./i18n
    ./media.nix
    ./nvidia.nix
    ./security.nix
  ];

  options = {
    presets.system.default.enable = mkOption {
      type = types.bool;
      description = "Whether to enable the base system preset.";
      default = true;
      example = true;
    };
  };

  config = mkIf config.presets.system.default.enable {
    environment.sessionVariables.MOZ_ENABLE_WAYLAND = 0;

    environment.systemPackages = with pkgs; [
      bind
      curl
      fzf
      git
      go
      jq
      libgccjit
      lua
      nodejs_latest
      protonvpn-gui
      ripgrep
      tree
      unzip
      vim
      wireguard-tools
      wget
      which
      zip
    ];

    fonts.packages = with pkgs; [
      (nerdfonts.override { fonts = [ "CascadiaMono" ]; })
    ];

    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;

    programs._1password-gui.enable = mkIf (!wsl) true;

    nix.extraOptions = "warn-dirty = false";
    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 1w";
    };
    nix.settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
    };

    nixpkgs.config.allowUnfree = true;

    services.tailscale.enable = true;

    services.xserver.desktopManager.xterm.enable = false;
    services.xserver.excludePackages = [ pkgs.xterm ];

    systemd.services.docker-desktop-proxy.script = mkForce ''${config.wsl.wslConf.automount.root}/wsl/docker-desktop/docker-desktop-user-distro proxy --docker-desktop-root ${config.wsl.wslConf.automount.root}/wsl/docker-desktop "C:\Program Files\Docker\Docker\resources"'';

    virtualisation = {
      docker = {
        enable = true;
        enableOnBoot = true;
        autoPrune.enable = true;
      };

      podman = mkIf (!wsl) {
        enable = true;
        defaultNetwork.settings.dns_enabled = true;
      };
    };

    wsl.extraBin = with pkgs; [
      { src = "${coreutils}/bin/mkdir"; }
      { src = "${coreutils}/bin/cat"; }
      { src = "${coreutils}/bin/whoami"; }
      { src = "${coreutils}/bin/ls"; }
      { src = "${busybox}/bin/addgroup"; }
      { src = "${su}/bin/groupadd"; }
      { src = "${su}/bin/usermod"; }
    ];
  };
}
