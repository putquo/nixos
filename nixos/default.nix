{ inputs, lib' }: let
  hosts = with lib'; bootstrap.nixos.hosts {
    hotel = { system = "x86_64-linux"; };
    whiskey = { system = "x86_64-linux"; };
  };
in { inherit (hosts) nixosConfigurations; }
