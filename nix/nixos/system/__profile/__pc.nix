{ inputs, ... }@_haumeaArgs:
{ lib, pkgs, ... }@_nixosModuleArgs: {
  imports = [
    inputs.cosmic.nixosModules.default
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
  nix.settings.substituters = [
    "https://anyrun.cachix.org"
    "https://cosmic.cachix.org"
    "https://devenv.cachix.org"
    "https://helix.cachix.org"
    "https://hyprland.cachix.org"
    "https://nix-community.cachix.org"
    "https://yazi.cachix.org"
  ];
  nix.settings.trusted-public-keys = [
    "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
    "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
    "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
    "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
    "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    "yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k="
  ];
  nix.settings.trusted-users = [
    "@wheel"
  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    inputs.nur.overlay
    (final: prev: {
      _1password-gui = prev._1password-gui.overrideAttrs (prev: {
        postInstall = (prev.postInstall or "") + ''
          mkdir -p $out/etc/xdg/autostart
          cp $out/share/applications/${prev.pname}.desktop $out/etc/xdg/autostart/${prev.pname}.desktop
          substituteInPlace $out/etc/xdg/autostart/${prev.pname}.desktop \
            --replace 'Exec=${prev.pname} %U' 'Exec=${prev.pname} --silent %U'
        '';
      });

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
  security.pam.u2f.settings.cue = true;

  services.fstrim.enable = true;

  time.timeZone = "Europe/Amsterdam";
}
