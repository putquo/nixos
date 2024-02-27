{ inputs, }: let
  inherit (inputs.nixpkgs) lib;
  configuration = ./configuration.nix;
  hardware = ./hardware.nix;
  home-manager = inputs.home-manager.nixosModules.home-manager;
  presets = ../../presets;
in lib.nixosSystem {
  system = "x86_64-linux";
  modules = [ 
    configuration
    hardware
    home-manager
    presets
  ];
}
