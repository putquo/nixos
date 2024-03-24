{ config, lib, lib', pkgs, ... }: with lib'; templated.preset "gaming" {
  inherit config;
  whenEnabled = {
    programs.gamescope.enable = true;
    programs.gamescope.capSysNice = true;

    programs.steam.enable = true;
    programs.steam.gamescopeSession.enable = true;
  };
}
