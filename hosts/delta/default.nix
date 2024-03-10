{ inputs, }: let
  inherit (inputs.nixpkgs) lib;
  configuration = ./configuration.nix;
  hardware = ./hardware.nix;
  home-manager = inputs.home-manager.nixosModules.home-manager;
  pkgs = import inputs.nixpkgs { inherit system; };
  presets = ../../presets;
  specialArgs.stencils = import ../../stencils { inherit pkgs; };
  system = "x86_64-linux";
in lib.nixosSystem {
  inherit specialArgs system;
  modules = [ configuration hardware home-manager presets ];
}
