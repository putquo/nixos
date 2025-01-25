{ ... }@_haumeaArgs:
{ pkgs, ... }@_nixosModuleArgs: {
  environment.systemPackages = with pkgs; [
    python3
  ];

  hardware.xpadneo.enable = true;

  programs.gamescope.enable = true;
  programs.gamescope.capSysNice = true;

  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
}
