{ pkgs }: user: { config, withOverrides }: with pkgs.lib; {
  options = {
    users.${user}.enable = mkEnableOption "the '${user}' user";
  };

  config = mkIf config.users.${user}.enable (
    mkMerge [
      {
        home-manager.users.${user} = {
          imports = [
            ../presets/user
          ];
        };

        programs = {
          _1password-gui.polkitPolicyOwners = [ user ];

          fish.enable = true;
        };

        users.users.${user} = {
          extraGroups = [ "docker" "networkmanager" "wheel" ];
          isNormalUser = true;
          description = "Preston van Tonder";
          shell = pkgs.nushell;
        };

        wsl.defaultUser = user;
      }
      withOverrides
    ]
  );
}
