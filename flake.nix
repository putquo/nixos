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

  outputs = { self, nixpkgs, ... }@inputs: let
    delta.nixos = import ./hosts/delta { inherit inputs; };
    delta.users = delta.nixos.config.home-manager.users;
    delta.justin = delta.users.justin.home;
    delta.work = delta.users.work.home;
  in {
    nixosConfigurations.delta = delta.nixos;

    homeConfigurations."justin@delta" = delta.justin;
    homeConfigurations."work@delta" = delta.formelio;
  };
}
