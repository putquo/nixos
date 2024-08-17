{ inputs, ... }@_haumeaArgs:
{ lib, pkgs, ... }@_nixosModuleArgs: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

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

  home-manager.sharedModules = [
    {
      options.tag = lib.mkOption {
        description = "A tag for additional metadata";
        type = lib.types.str;
      };
    }
    inputs.anyrun.homeManagerModules.default
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  networking.networkmanager.enable = true;
  networking.useDHCP = lib.mkDefault true;

  nix.extraOptions = ''
    experimental-features = nix-command flakes
    warn-dirty = false
  '';

  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 7d";
  nix.settings.auto-optimise-store = true;
  nix.settings.trusted-users = [
    "@wheel"
  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    inputs.nur.overlay
    (final: prev: {
      anyrun = inputs.anyrun.packages.anyrun-with-all-plugins;

      fprintd = prev.fprintd.overrideAttrs (prev: {
        mesonCheckFlags = [
          "--no-suite"
          "fprintd:TestPamFprintd"
        ];
      });

      grimblast = inputs.hyprcontrib.packages.grimblast;
      helix = inputs.helix.packages.default;
      hypridle = inputs.hypridle.packages.default;
      hyprland = inputs.hyprland.packages.default;
      hyprlandPlugins.hyprexpo = inputs.hyprland-plugins.packages.hyprexpo;
      hyprlock = inputs.hyprlock.packages.default;
      wallpaper = "${inputs.self}/assets/bg01.svg";

      wbg = prev.wbg.override {
        enablePNG = false;
        enableJPEG = false;
        enableWebp = false;
      };

      xdg-desktop-portal-hyprland = inputs.hyprland.packages.xdg-desktop-portal-hyprland;
      yazi = inputs.yazi.packages.default;
    })
  ];

  programs._1password.enable = true;
  programs._1password-gui.enable = true;
  programs.fish.enable = true;

  security.pam.u2f.enable = true;
  security.pam.u2f.control = "sufficient";
  security.pam.u2f.cue = true;

  services.fstrim.enable = true;

  sound.enable = true;
  time.timeZone = "Europe/Amsterdam";
}
