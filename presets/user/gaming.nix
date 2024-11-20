{ config, lib, pkgs, ... }: with lib; {
  options = {
    presets.user.gaming.enable = mkEnableOption "the gaming user preset";
  };

  config = mkIf config.presets.user.gaming.enable {
    programs = {
      mangohud = {
        enable = true;
        settings = {
          full = true;
          no_display = true;
          preset = 3;
        };
      };
    };
  };
}
