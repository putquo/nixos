{ inputs }: username: { config, lib, pkgs, withOverrides, tag }: {
  options.users.${username}.enable = lib.mkEnableOption "Enable '${username}' with tag='${tag}'";

  config = lib.mkIf config.users.${username}.enable (
    lib.mkMerge [
      {
        home-manager = {
          users.${username} = {
            inherit tag;
            presets.desktop.enable = config.presets.desktop.enable;
          };
        };

        programs._1password-gui.polkitPolicyOwners = [ username ];

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
