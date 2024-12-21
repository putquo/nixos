{ inputs, ... }@_haumeaArgs:
{ lib, pkgs, ... }@_nixosModuleArgs: {
  imports = [
    inputs.cosmic.nixosModules.default
    inputs.home-manager.nixosModules.home-manager
    inputs.stylix.nixosModules.stylix
  ];

  environment.systemPackages = with pkgs; [
    curl
    vim
    wget
  ];

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    nerd-fonts.monaspace
  ];

  home-manager.backupFileExtension = "backup";
  home-manager.verbose = true;
  home-manager.sharedModules = [
    {
      options.tag = lib.mkOption {
        description = "A tag for additional metadata";
        type = lib.types.str;
      };
    }
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
    "https://nix-community.cachix.org"
    "https://yazi.cachix.org"
  ];
  nix.settings.trusted-public-keys = [
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    "yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k="
  ];
  nix.settings.trusted-users = [
    "@wheel"
  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    inputs.nur.overlays.default
    (final: prev: {
      _1password-gui = prev._1password-gui.overrideAttrs (prev: {
        postInstall = (prev.postInstall or "") + ''
          mkdir -p $out/etc/xdg/autostart
          cp $out/share/applications/${prev.pname}.desktop $out/etc/xdg/autostart/${prev.pname}.desktop
          substituteInPlace $out/etc/xdg/autostart/${prev.pname}.desktop \
            --replace 'Exec=${prev.pname} %U' 'Exec=${prev.pname} --silent %U'
        '';
      });

      fprintd = prev.fprintd.overrideAttrs (prev: {
        mesonCheckFlags = [
          "--no-suite"
          "fprintd:TestPamFprintd"
        ];
      });

      helix = inputs.helix.packages.default;
      wallpaper = "${inputs.self}/assets/bg01.svg";

      yazi = inputs.yazi.packages.default;

      openvpn3 = inputs.nixpkgs-stable.legacyPackages.openvpn3;
    })
  ];

  programs._1password.enable = true;
  programs._1password-gui.enable = true;
  programs.fish.enable = true;

  security.pam.u2f.enable = true;
  security.pam.u2f.control = "sufficient";
  security.pam.u2f.settings.cue = true;

  services.fstrim.enable = true;
  services.tailscale.enable = true;

  stylix.enable = true;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/dracula.yaml";
  stylix.cursor = {
    name = "Pop";
    package = pkgs.pop-icon-theme;
    size = 28;
  };
  stylix.fonts = {
    serif = {
      name = "Noto Serif";
      package = pkgs.noto-fonts;
    };

    sansSerif = {
      name = "Noto Sans";
      package = pkgs.noto-fonts;
    };

    monospace = {
      name = "MonaspiceNe Nerd Font Mono";
      package = pkgs.nerd-fonts.monaspace;
    };
  };
  stylix.image = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/aynp/dracula-wallpapers/refs/heads/main/Art/4k/Dracula.png";
    sha256 = "sha256-+kZN+QqB7AOjqJXvuNAhoPApbi5JR+cwtCgWOD8vJ4E=";
  };

  time.timeZone = "Europe/Amsterdam";
}
