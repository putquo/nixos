{ lib', inputs }: let
  inherit (inputs.nixpkgs) lib;
  hosts = import ./hosts.nix { inherit inputs system; };
  system = import ./system.nix { inherit lib' inputs; };
  user = import ./user.nix { inherit inputs; };
in { inherit hosts system user; }
