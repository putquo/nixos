{ config, lib, pkgs, ... }: with lib; {
  options = {
    presets.system.security.enable = mkEnableOption "the security system preset";
  };

  config = mkIf config.presets.system.security.enable {
    security.pam.u2f = {
      enable = true;
      control = "sufficient";
      settings.cue = true;
    };
  };
}
