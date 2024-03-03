{ inputs, }: let
  inherit (inputs) nixpkgs;
  inherit (nixpkgs) lib;

  system = "x86_64-linux";
  pkgs = import nixpkgs { inherit system; };

  configuration = ./configuration.nix;
  hardware = ./hardware.nix;
  presets = ../../presets;

  home-manager = inputs.home-manager.nixosModules.home-manager;

  specialArgs.stencils = import ../../stencils { inherit pkgs; };
in lib.nixosSystem {
  inherit specialArgs;
  inherit system;

  modules = [ 
    configuration
    hardware
    home-manager
    presets
  ];
}
