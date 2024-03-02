{ config, lib, pkgs, ... }: {
  options = {
    presets.system.base.enable = lib.mkEnableOption {
      default = false;
      description = "Enable base system preset";
    };
  };

  config = lib.mkIf config.presets.system.base.enable {
    environment.systemPackages = with pkgs; [
      curl
      fzf
      just
      ripgrep
      vim
      wget
    ];

    fonts.packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" ]; })
    ];

    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;

    nix.extraOptions = ''
      experimental-features = nix-command flakes
      warn-dirty = false
    '';
    nixpkgs.config.allowUnfree = true;

    programs = {
      _1password.enable = true;
      _1password-gui.enable = true;
      _1password-gui.polkitPolicyOwners = with builtins;
        filter 
        (name: config.presets.user.${name}.enable)
        (attrNames config.presets.user);

      fish.enable = true;
    };

    security.pam.u2f = {
      enable = true;
      control = "sufficient";
      cue = true;
    };

    time.timeZone = "Europe/Amsterdam";
  };
}
