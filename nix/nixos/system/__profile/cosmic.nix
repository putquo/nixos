{ ... }@_haumeaArgs:
{ pkgs, ... }@_nixosModuleArgs: {
  environment.cosmic.excludePackages = with pkgs; [
    cosmic-edit
    cosmic-term
    fira
  ];
  services.desktopManager.cosmic.enable = true;
  services.displayManager.cosmic-greeter.enable = true;
}
