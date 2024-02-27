{ config, lib, pkgs, ... }: {
  options = {
    presets.system.gaming.enable = lib.mkEnableOption {
      default = false;
      description = "Enable gaming system preset";
    };
  };

  config = lib.mkIf config.presets.system.gaming.enable {
    programs = {
      gamescope.enable = true;
      gamescope.capSysNice = true;

      steam.enable = true;
      steam.gamescopeSession.enable = true;
    };
  };
}
