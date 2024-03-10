flake: hostname: let
  host = import ../hosts/${hostname};
  homeManager = flake.home-manager.nixosModules.home-manager;
  nixos = flake.nixpkgs.lib.nixosSystem {
    inherit (host) system;
    inherit specialArgs;
    modules = host.modules ++ [ homeManager presets ];
  };
  presets = ../presets;
  specialArgs.stencils = import ./.;
  userHomes = builtins.mapAttrs (username: config: config.home) nixos.config.home-manager.users;
in { inherit nixos; } // userHomes
