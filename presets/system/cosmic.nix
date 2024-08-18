{ config, lib, pkgs, ... }: with lib; {
  options = {
    presets.system.cosmic.enable = mkEnableOption "the COSMIC system preset";
  };

  config = mkIf config.presets.system.cosmic.enable {
    nix.settings = {
      substituters = [ "https://cosmic.cachix.org" ];
      trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
    };

    services.desktopManager.cosmic.enable = true;
    services.displayManager.cosmic-greeter.enable = true;
  };
}
