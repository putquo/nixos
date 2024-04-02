{ config, lib, lib', pkgs, ... }: with lib'; templated.user "justin" {
  inherit config lib pkgs;
  tag = "Personal";
  withOverrides = {
    home-manager.users.justin = {
      presets.gaming.enable = true;
      programs.git.extraConfig.user.signingKey =
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFCIGXttA+0HUZtaya0T2klbNSrxonbJ8BEmi4L8+/MM";
    };
  };
}
