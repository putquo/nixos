{ inputs, lib' }: let inherit (inputs.nixpkgs) lib; in {
  preset = import ./preset.nix { inherit lib; };
  user = import ./user.nix { inherit inputs; };
}
