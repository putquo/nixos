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
    nur.url = "github:nix-community/nur";
  };

  outputs = inputs: let
    lib' = import ./lib { inherit inputs; };
    nixosOutputs = import ./nixos { inherit inputs lib'; };
  in {
    # dbg = nixosOutputs;
    inherit (nixosOutputs) nixosConfigurations;
  };
}
