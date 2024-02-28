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
    talos.nixos = import ./hosts/talos { inherit inputs; };
    talos.users = talos.nixos.config.home-manager.users;
    talos.justin = talos.users.justin.home;
    talos.formelio = talos.users.formelio.home;
  in {
    nixosConfigurations.talos = talos.nixos;

    homeConfigurations."justin@talos" = talos.justin;
    homeConfigurations."formelio@talos" = talos.formelio;
  };
}
