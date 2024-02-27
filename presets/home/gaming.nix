{ config, lib, pkgs, ... }: {
  options = {
    presets.home.gaming.enable = lib.mkEnableOption {
      default = false;
      description = "Enable gaming home preset";
    };
  };

  config = lib.mkIf config.presets.home.gaming.enable {
    programs = {
      mangohud.enable = true;
    }; 
  };
}
