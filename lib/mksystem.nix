{ inputs }: host: { system, wsl ? false }:
let
  inherit (inputs.nixpkgs) lib;
  overlays = import ../overlays { inherit inputs; };
  homeManager = inputs.home-manager.nixosModules.home-manager;
  hostConfig = ../hosts/${host}/configuration.nix;
  nixosCosmic = inputs.nixos-cosmic.nixosModules.default;
  nixosWsl = inputs.nixos-wsl.nixosModules.wsl;
  pkgs = import inputs.nixpkgs { inherit system; };
  specialArgs.schematics = import ../schematics { inherit pkgs; };
  systemFunc = lib.nixosSystem;
  systemPresets = ../presets/system;
  userConfig = ../users;
in
systemFunc {
  inherit specialArgs system;
  modules = [
    homeManager
    hostConfig
    nixosCosmic
    nixosWsl
    systemPresets
    userConfig
    { nixpkgs.overlays = overlays; }
    { wsl.enable = wsl; }
  ];
}
