{ pkgs, ... }: {
  user = import ./user.nix { inherit pkgs; };
}
