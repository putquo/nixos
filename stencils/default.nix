{ pkgs }: {
  module.preset.user = import ./user-preset.nix { inherit pkgs; };
}
