{ inputs }: host: { system, wsl ? false }:
let
  inherit (inputs.nixpkgs) lib;
  overlays = import ../overlays { inherit inputs; };
  homeManager = inputs.home-manager.nixosModules.home-manager;
  hostConfig = ../hosts/${host}/configuration.nix;
  nixosWsl = inputs.nixos-wsl.nixosModules.wsl;
  pkgs = import inputs.nixpkgs { inherit system; };
  specialArgs.schematics = import ../schematics { inherit pkgs; };
  systemFunc = lib.nixosSystem;
  systemPresets = ../presets/system;
  userConfig = ../users;
in systemFunc {
  inherit specialArgs system;
  modules = [
    homeManager
    hostConfig
    nixosWsl
    systemPresets
    userConfig
    { nixpkgs.overlays = overlays; }
    { wsl.enable = wsl; }
  ];
}
