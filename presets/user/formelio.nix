{ config, lib, pkgs, ... }: {
  options = {
    presets.user.formelio.enable = lib.mkEnableOption {
      default = false;
      description = "Enable Formelio (work) user preset";
    };
  };

  config = lib.mkIf config.presets.user.formelio.enable {
    home-manager = {
      users.formelio = {
        imports = [
          ../home
        ];
        
        home = {
          inherit (config.system) stateVersion;  
          username = "formelio";
          homeDirectory = "/home/formelio";

          packages = with pkgs; [
            google-cloud-sdk
            k6
            kubectl
            kubelogin-oidc
            kubernetes-helm
            kubernetes-helmPlugins.helm-secrets
            maven
            mongosh
            openvpn
            slack
            sops
            yarn
            yaml-language-server
          ];
        };

        presets.home.base.enable = true;
        presets.home.development.enable = true;

        programs = {
          git.extraConfig.user.signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBRTP702lUz73eZnq5TZXdkb2AkNvJbNuHLBXt42kv66";
          git.userEmail = "jan.justin.vtonder@gmail.com";
        };

        xdg.desktopEntries.steam.exec = "";
        xdg.desktopEntries.steam.name = "Steam";
        xdg.desktopEntries.steam.noDisplay = true;
      };
    };

    users.users.formelio = {
      extraGroups = [ "networkmanager" "wheel" ];
      initialPassword = "initPass";
      isNormalUser = true;
      shell = pkgs.fish;
    };
  };
}
