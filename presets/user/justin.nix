{ config, lib, pkgs, ... }: {
  options = {
    presets.user.justin.enable = lib.mkEnableOption {
      default = false;
      description = "Enable personal user preset";
    };
  };

  config = lib.mkIf config.presets.user.justin.enable {
    home-manager = {
      users.justin = {
        imports = [
          ../home
        ];

        home = {
          inherit (config.system) stateVersion;  
          username = "justin";
          homeDirectory = "/home/justin";
        };

        presets.home.base.enable = true;
        presets.home.development.enable = true;
        presets.home.gaming.enable = true;

        programs = {
          git.extraConfig.user.signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFCIGXttA+0HUZtaya0T2klbNSrxonbJ8BEmi4L8+/MM";
          git.userEmail = "jan.justin.vtonder@gmail.com";
        };
      };
    };

    users.users.justin = {
      extraGroups = [ "networkmanager" "wheel" ];
      initialPassword = "initPass";
      isNormalUser = true;
      shell = pkgs.fish;
    };
  };
}
