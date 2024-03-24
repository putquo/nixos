{ inputs, system }: hosts: let
  inherit (inputs.nixpkgs) lib;
  systems = with lib; mapAttrs
    (hostName: params: system ({ inherit hostName; } // params))
    hosts;
in {
  nixosConfigurations = with lib; mapAttrs
    (hostName: _params: systems.${hostName}.nixosConfiguration)
    hosts;
}
