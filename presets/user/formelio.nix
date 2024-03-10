{ config, lib, pkgs, stencils, ... }: let 
  username = "formelio";
  tag = "Formelio";
in stencils.module.preset.user username {
  inherit config tag;
  withOverrides = {
    home-manager.users.${username} = {
      home.packages = with pkgs; [
        google-cloud-sdk
        jetbrains.idea-community-bin
        k6
        kubectl
        kubelogin-oidc
        maven
        mongosh
        openvpn
        slack
        sops
        yarn
        yaml-language-server

        (wrapHelm kubernetes-helm {
          plugins = [
            kubernetes-helmPlugins.helm-secrets
          ];
        })
      ];

      presets.home.development.enable = true;

      programs = {
        k9s.enable = true;
        java.enable = true;
        java.package = pkgs.jdk17;
        git.extraConfig.user.signingKey =
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBRTP702lUz73eZnq5TZXdkb2AkNvJbNuHLBXt42kv66";
      };


      xdg.desktopEntries.steam.exec = "";
      xdg.desktopEntries.steam.name = "Steam";
      xdg.desktopEntries.steam.noDisplay = true;
    };
  };
}
