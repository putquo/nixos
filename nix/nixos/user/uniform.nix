{ name, super, ... }@_haumeaArgs:
{ config, pkgs, ... }@_nixosModuleArgs: {
  imports = [
    # Remove some boilerplate
    (super.pc-user {
      tag = "Formelio";
      username = name;
    })
  ];

  home-manager.users.${name} = {
    imports = [
      super.profile.development
      super.profile.kde
    ];

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

    programs.git.extraConfig.user.signingKey =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBRTP702lUz73eZnq5TZXdkb2AkNvJbNuHLBXt42kv66";

    programs.java.enable = true;
    programs.java.package = pkgs.jdk17;

    programs.k9s.enable = true;
    programs.k9s.skins = super.misc.k9s-skins;
    programs.k9s.settings = {
      k9s = {
        shellPod = {
          image = "nixos/nix";
          namespace = "default";
          limits = {
            cpu = "100m";
            memory = "200Mi";
          };
        };
        thresholds = {
          cpu = {
            critical = 90;
            warn = 70;
          };
          memory = {
            critical = 90;
            warn = 85;
          };
        };
        ui = {
          logoless = true;
          reactive = true;
          skin = "rpine";
        };
      };
    };

    services.darkman =
      let
        k9sSkinsDir = "${config.home-manager.users.uniform.xdg.configHome}/k9s/skins";
        k9sSkin = "${k9sSkinsDir}/rpine.yaml";
      in
      {
        darkModeScripts.k9s = ''
          /usr/bin/env -S ln -sf "${k9sSkinsDir}/rose-pine-moon.yaml" "${k9sSkin}"
        '';
        lightModeScripts.k9s = ''
          /usr/bin/env -S ln -sf "${k9sSkinsDir}/rose-pine-dawn.yaml" "${k9sSkin}"
        '';
      };
  };
}
