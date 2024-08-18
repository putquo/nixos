{
  description = "Nix-based system configuration";

  inputs = {
    anyrun.url = "github:Kirottu/anyrun";
    anyrun.inputs.nixpkgs.follows = "nixpkgs";

    cosmic.url = "github:lilyinstarlight/nixos-cosmic";
    cosmic.inputs.nixpkgs.follows = "nixpkgs";

    devenv.url = "github:cachix/devenv";

    haumea.url = "github:nix-community/haumea";
    haumea.inputs.nixpkgs.follows = "nixpkgs";

    helix.url = "github:helix-editor/helix";
    helix.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    hyprcontrib.url = "github:hyprwm/contrib";
    hyprcontrib.inputs.nixpkgs.follows = "nixpkgs";

    hypridle.url = "github:hyprwm/hypridle";
    hypridle.inputs.hyprlang.follows = "hyprland/hyprlang";
    hypridle.inputs.nixpkgs.follows = "nixpkgs";
    hypridle.inputs.systems.follows = "hyprland/systems";

    hyprland.url = "https://github.com/hyprwm/Hyprland";
    hyprland.type = "git";
    hyprland.submodules = true;
    hyprland.inputs.nixpkgs.follows = "nixpkgs";

    hyprland-plugins.url = "github:hyprwm/hyprland-plugins";
    hyprland-plugins.inputs.hyprland.follows = "hyprland";

    hyprlock.url = "github:hyprwm/hyprlock";
    hyprlock.inputs.hyprlang.follows = "hyprland/hyprlang";
    hyprlock.inputs.nixpkgs.follows = "nixpkgs";
    hyprlock.inputs.systems.follows = "hyprland/systems";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nur.url = "github:nix-community/nur";

    std.url = "github:divnix/std";
    std.inputs.nixpkgs.follows = "nixpkgs";

    yazi.url = "github:sxyazi/yazi";
    yazi.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, self, std, ... }@inputs:
    let
      system.harvest = target: path:
        nixpkgs.lib.attrsets.mapAttrs
          (systemName: { host, profiles, users }:
            nixpkgs.lib.nixosSystem {
              modules = [ host ] ++ profiles ++ users;
            }
          )
          (std.harvest target path)."x86_64-linux";
    in
    std.growOn
      {
        inherit inputs;
        cellsFrom = ./nix;
        cellBlocks = [
          # nixos
          (std.blockTypes.functions "host")
          (std.blockTypes.functions "system")
          (std.blockTypes.functions "user")
          # support
          (std.blockTypes.functions "lib")
          (std.blockTypes.functions "shell")
        ];
      }
      {
        devShells = std.harvest self [ "support" "shell" ];
        nixosConfigurations = system.harvest self [ "nixos" "system" ];
      };
}
