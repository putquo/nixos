{ ... }@_haumeaArgs:
{ pkgs, ... }@_nixosModuleArgs: {
  environment.cosmic.excludePackages = with pkgs; [
    cosmic-edit
    cosmic-term
    fira
  ];

  nix.settings.substituters = [
    "https://cosmic.cachix.org"
  ];
  nix.settings.trusted-public-keys = [
    "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
  ];

  services.desktopManager.cosmic.enable = true;
  services.displayManager.cosmic-greeter.enable = true;
}
