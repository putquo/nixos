{ inputs, lib' }: { hostName, system }: let
  inherit (inputs.nixpkgs) lib;
  flake = inputs.self;
  host = import "${flake}/nixos/hosts/${hostName}";
  homeManager = inputs.home-manager.nixosModules.home-manager;
  presets = import "${flake}/nixos/presets";
  specialArgs.lib' = lib';
  users = import "${flake}/users";
  _additions.networking = { inherit hostName; };
  _additions.home-manager.extraSpecialArgs = { inherit lib'; };
  _additions.home-manager.sharedModules = [ (import "${flake}/home") ];
  _additions.home-manager.useGlobalPkgs = true;
  _additions.home-manager.useUserPackages = true;
in {
  nixosConfiguration = with lib; nixosSystem {
    inherit specialArgs system;
    modules = [ _additions homeManager host presets users ];
  };
}
