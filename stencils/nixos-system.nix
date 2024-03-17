{ inputs, stencils }: { hostname, system }: let
  inherit (inputs.nixpkgs) lib;
  host = import ../hosts/${hostname};
  homeManager = inputs.home-manager.nixosModules.home-manager;
  presets = ../presets;
  specialArgs.stencils = stencils;
in rec {
  # TODO: Fix or remove
  homeConfigurations = with lib; mapAttrs' 
    (user: config: nameValuePair ("${user}@${hostname}") (config.home))
    nixosConfiguration.config.home-manager.users; 

  nixosConfiguration = lib.nixosSystem {
    inherit specialArgs system;
    modules = [
      { networking.hostName = hostname; }
      homeManager
      host
      presets
    ];
  };
}
