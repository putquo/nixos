flake: hostname: let
  host = import ../hosts/${hostname};
  homeManager = flake.home-manager.nixosModules.home-manager;
  presets = ../presets;
  specialArgs.stencils = import ./.;
in rec {
  homeConfigurations = with flake.nixpkgs.lib; mapAttrs' 
    (user: config: nameValuePair ("${user}@${hostname}") (config.home))
    nixosConfiguration.config.home-manager.users; 
  nixosConfiguration = flake.nixpkgs.lib.nixosSystem {
    inherit (host) system;
    inherit specialArgs;
    modules = host.modules ++ [ { networking.hostName = hostname; } homeManager presets ];
  };
}
