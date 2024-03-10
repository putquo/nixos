{ config, lib, pkgs, stencils, ... }: let
  username = "justin";
  tag = "Personal";
in stencils.module.preset.user username {
  inherit config lib pkgs tag;
  withOverrides = {
    home-manager.users.${username} = {
      presets.home.development.enable = true;
      presets.home.gaming.enable = true;
      programs.git.extraConfig.user.signingKey = 
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFCIGXttA+0HUZtaya0T2klbNSrxonbJ8BEmi4L8+/MM";
    };
  };
}
