inputs: let
  inherit (inputs.nixpkgs) lib;
  nixosHosts = hosts: let
    systems = lib.mapAttrs
      (host: params: nixosSystem ({ hostname = host; } // params))
      hosts;
  in rec {
    homeConfigurations = lib.foldlAttrs
      (acc: attr: conf: if attr == "homeConfigurations" then conf else { })
      { }
      nixosConfigurations;

    nixosConfigurations = lib.mapAttrs
      (host: _params: systems.${host}.nixosConfiguration)
      hosts;
  };
  nixosSystem = import ./nixos-system.nix {
    inherit inputs;
    stencils = _self;
  };
  userPreset = import ./user-preset.nix;
  _self = {
    module.preset.user = userPreset;
    nixos.hosts = nixosHosts;
  };
in _self
