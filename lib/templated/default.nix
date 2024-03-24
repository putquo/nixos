{ inputs, lib' }: let inherit (inputs.nixpkgs) lib; in {
  preset = import ./preset.nix { inherit lib; };
}
