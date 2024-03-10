username: { config, lib, pkgs, withOverrides, tag }: let
  homeDirectory = "/home/${username}";
in {
  options = {
    presets.user.${username}.enable = lib.mkEnableOption {
      default = false;
      description = "Enable ${tag} user preset";
    };
  };

  config = lib.mkIf config.presets.user.${username}.enable (
    lib.mkMerge [
      {
        home-manager = {
          users.${username} = {
            imports = [
              ../presets/home
            ];

            presets.home.base.enable = true;
          };
        };

        programs = {
          _1password-gui.polkitPolicyOwners = [ username ];
        };

        users.users.${username} = {
          extraGroups = [ "networkmanager" "wheel" ];
          initialPassword = "initPass";
          isNormalUser = true;
          shell = pkgs.fish;
        };
      }
      withOverrides
    ]
  );
}
