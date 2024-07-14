{ ... }@_haumeaArgs:
{ ... }@_nixosModuleArgs: {
  programs.gamescope.enable = true;
  programs.gamescope.capSysNice = true;

  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
}
