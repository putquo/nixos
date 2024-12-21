{ name, super, ... }@_haumeaArgs:
{ config, pkgs, ... }@_nixosModuleArgs: {
  imports = [
    # Remove some boilerplate
    (super.pc-user {
      tag = "Work";
      username = name;
    })
  ];

  home-manager.users.${name} = {
    imports = [
      super.profile.development
    ];

    home.packages = with pkgs; [
      gnumake
      google-cloud-sdk
      jetbrains.idea-community-bin
      kubectl
      kubelogin-oidc
      slack
      sops
      yaml-language-server

      (wrapHelm kubernetes-helm {
        plugins = [
          kubernetes-helmPlugins.helm-secrets
        ];
      })
    ];

    programs.git.extraConfig.user.signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK4z+GCnpEmPq2uRl1Ol8a83Xjmeiqk1q8XV3cZh7pWZ";

    programs.java.enable = true;
    programs.java.package = pkgs.jdk17;

    programs.k9s.enable = true;
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
        };
      };
    };

    xdg.configFile."Yubico/u2f_keys".text =
      "toil:YRyD9p+nEgdTnj6DefvG2pey7mVGn931NnfmyRhhU6ObaPRPF+RYDRH0YXU1go0r4XClZpubnXUSAA2soUfiDg=="
      + ",onnVg36QcW0RSU7ij+mIOjvVm71KrAOZ2/Y1k0kL/6sFD1ggWAa4NvWv4ZOyRc1MfXEmY6+qFNaUJRMTbab/EQ=="
      + ",es256,+presence:UKD6uA7TxPZxHlX5CNlSkXfNcncOJ9O6XGWVcEDpftYzY0gaqaWknCc193a0j7tuzBUN3JUKQVxjURUaC3UkrQ=="
      + ",3LkMS/SIv0WD7l/L/Og0Bj6tWxrLDbfTtR9V+0RUwADaXWNFbzvVfM5KzaWWviOT/fVcZoN+9ibXwuMGrRmzsw==,es256,+presence"
      + ":LqQyzxoluRwdLiVchvSpkW0Tw+16UY1qFx85DcYWW4FuK+AEiKMWtctTZnyGzLcaFirNK5Et4HkLPvh91UkRyw=="
      + ",P+ikZBs2dfg9zX+OE9+LpsaC1TCdul1Ny6O5bdjgwsuDjj/btgphW0fgY0MXKAh2hF4Cm0c6rw5RjzXpriKn0w==,es256,+presence";
  };

  programs.openvpn3.enable = true;

  services.udev.packages = [
    pkgs.android-udev-rules
  ];
}
