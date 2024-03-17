{
  description = "Nix-based system configuration";

  nixConfig = {
    substituters = [
      "https://cache.nixos.org/"
    ];
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  }; 
  
  inputs = {
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs: let
    nixosHosts = stencils.nixos.hosts {
      hotel = { system = "x86_64-linux"; };
      whiskey = { system = "x86_64-linux"; };
    };
    stencils = import ./stencils inputs;
  in {
    inherit (nixosHosts)
      homeConfigurations
      nixosConfigurations;
  };
}
