{ inputs }: let
  inherit (inputs.nixpkgs) lib;
  devShells = forEachSupportedSystem (pkgs: {
    default = with pkgs; mkShell {
      packages = [
        deadnix
        nil
        nixfmt
        statix
      ];
    };
  });
  forEachSupportedSystem = do:
    with lib; genAttrs supportedSystems
      (system: do (import inputs.nixpkgs { inherit system; }));
  supportedSystems = [ "x86_64-linux" ];
in { inherit devShells; }
