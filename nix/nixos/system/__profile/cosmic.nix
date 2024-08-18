{ ... }@_haumeaArgs:
{ ... }@_nixosModuleArgs: {
  services.desktopManager.cosmic.enable = true;
  services.displayManager.cosmic-greeter.enable = true;
}
