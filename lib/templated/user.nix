{ inputs }: username: { config, lib, pkgs, withOverrides, tag }: {
  options.users.${username}.enable = lib.mkEnableOption "Enable '${username}' with tag='${tag}'";

  config = lib.mkIf config.users.${username}.enable (
    lib.mkMerge [
      {
        home-manager = {
          users.${username} = {
            inherit tag;
            presets.desktop.enable = lib.mkDefault config.presets.desktop.enable;
            presets.development.enable = lib.mkDefault config.presets.desktop.enable;
            presets.hyprland.enable = lib.mkDefault config.presets.hyprland.enable;
            presets.kde.enable = lib.mkDefault config.presets.kde.enable;
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
