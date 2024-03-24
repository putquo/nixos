{ config, lib, lib', pkgs, ... }: with lib'; bootstrap.user "justin" {
  inherit config lib pkgs;
  tag = "Personal";
  withOverrides = {
    home-manager.users.justin = {
      presets.development.enable = true;
      presets.gaming.enable = true;
      programs.git.extraConfig.user.signingKey = 
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFCIGXttA+0HUZtaya0T2klbNSrxonbJ8BEmi4L8+/MM";
    };
  };
}
