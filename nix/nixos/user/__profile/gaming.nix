{ ... }@_haumeaArgs:
{ config, lib, pkgs, ... }@_hmModuleArgs: {
  programs.mangohud.enable = true;
  programs.mangohud.settings.full = true;
  programs.mangohud.settings.no_display = true;
  programs.mangohud.settings.preset = 3;
}

