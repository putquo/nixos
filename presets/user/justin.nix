{ config, lib, pkgs, stencils, ... }: {
  options = {
    presets.user.justin.enable = lib.mkEnableOption {
      default = false;
      description = "Enable personal user preset";
    };
  };

  config = lib.mkIf config.presets.user.justin.enable (
    stencils.user "justin" {
      inherit config;
      extraConfig = {
        home-manager.users.justin = {
          presets.home.development.enable = true;
          presets.home.gaming.enable = true;
        };
      };
      signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFCIGXttA+0HUZtaya0T2klbNSrxonbJ8BEmi4L8+/MM";
    }
  );
}
