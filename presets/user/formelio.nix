{ config, lib, pkgs, stencils, ... }: {
  options = {
    presets.user.formelio.enable = lib.mkEnableOption {
      default = false;
      description = "Enable Formelio (work) user preset";
    };
  };

  config = lib.mkIf config.presets.user.formelio.enable (
    stencils.user "formelio" {
      inherit config;
      extraConfig = {
        home-manager.users.formelio = {
          home.packages = with pkgs; [
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

          presets.home.development.enable = true;

          programs = {
            k9s.enable = true;
          };

          xdg.desktopEntries.steam.exec = "";
          xdg.desktopEntries.steam.name = "Steam";
          xdg.desktopEntries.steam.noDisplay = true;
        };
      };
      signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBRTP702lUz73eZnq5TZXdkb2AkNvJbNuHLBXt42kv66";
    }
  ); 
}
