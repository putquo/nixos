{
  description = "My nix-based configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixos-cosmic.url = "github:lilyinstarlight/nixos-cosmic";
    nixos-cosmic.inputs.nixpkgs.follows = "nixpkgs";

    helix.url = "github:helix-editor/helix";
    helix.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixos-wsl.url = "github:nix-community/nixos-wsl";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";

    nur.url = "github:nix-community/nur";
  };

  outputs = { self, ... } @ inputs:
    let
      mkSystem = import ./lib/mksystem.nix { inherit inputs; };

      supportedSystems = [ "x86_64-linux" ];
      forEachSupportedSystem = f:
        inputs.nixpkgs.lib.genAttrs supportedSystems (system:
          f {
            pkgs = import inputs.nixpkgs { inherit system; };
          });
    in
    {
      nixosConfigurations = {
        byte = mkSystem "byte" {
          system = "x86_64-linux";
          wsl = true;
        };

        titan = mkSystem "titan" {
          system = "x86_64-linux";
        };
      };

      devShells = forEachSupportedSystem ({ pkgs }: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            deadnix
            nixpkgs-fmt
            statix
          ];
        };
      });
    };
}
