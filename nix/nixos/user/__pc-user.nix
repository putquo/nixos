{ super, ... }@_haumeaArgs:
{ tag, username }@_profileArgs:
{ pkgs, ... }@_nixosModuleArgs: {

  home-manager.users.${username} = {
    inherit tag;
    imports = [
      super.profile.pc
    ];

    stylix.targets.helix.enable = false;
  };

  programs._1password-gui.polkitPolicyOwners = [ username ];

  users.users.${username} = {
    description = tag;
    extraGroups = [ "networkmanager" "wheel" ];
    initialPassword = "initPass";
    isNormalUser = true;
    name = username;
    shell = pkgs.fish;
  };
}
