{
  description = "Nix-based system configuration";

  inputs = {
    anyrun.url = "github:Kirottu/anyrun";
    anyrun.inputs.nixpkgs.follows = "nixpkgs";

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

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nur.url = "github:nix-community/nur";

    yazi.url = "github:sxyazi/yazi";
    yazi.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs:
    let
      lib' = import ./lib { inherit inputs; };
      outputs.nixos = import ./nixos { inherit inputs lib'; };
      outputs.shells = import ./shells { inherit inputs; };
    in
    {
      inherit (outputs.nixos) nixosConfigurations;
      inherit (outputs.shells) devShells;
    };

  nixConfig = {
    substituters = [ "https://cache.nixos.org/" ];
    extra-substituters = [
      "https://anyrun.cachix.org"
      "https://helix.cachix.org"
      "https://hyprland.cachix.org"
      "https://nix-community.cachix.org"
      "https://yazi.cachix.org"
    ];
    extra-trusted-public-keys = [
      "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
      "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k="
    ];
  };
}
