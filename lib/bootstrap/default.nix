{ inputs, lib' }: {
  nixos = import ./nixos { inherit inputs lib'; };  
  user = import ./user { inherit inputs; };
}
