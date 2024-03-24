{ config, lib, lib', pkgs, ... }: with lib'; bootstrap.user "uniform" {
  inherit config lib pkgs;
  tag = "Formelio";
  withOverrides = {
    home-manager.users.uniform = {
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

      presets.development.enable = true;

      programs.k9s.enable = true;
      programs.java.enable = true;
      programs.java.package = pkgs.jdk17;
      programs.git.extraConfig.user.signingKey =
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBRTP702lUz73eZnq5TZXdkb2AkNvJbNuHLBXt42kv66";
    };
  };
}
