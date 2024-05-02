{ config, schematics, ...}: let
  putquo = "putquo";
in schematics.forUser putquo {
  inherit config;
  withOverrides = {
    home-manager.users.${putquo} = {
      presets.user.dconf.enable = true;
      presets.user.development.enable = true;

      programs = {
        git.userEmail = "46090392+putquo@users.noreply.github.com";
        git.extraConfig.user.signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK4z+GCnpEmPq2uRl1Ol8a83Xjmeiqk1q8XV3cZh7pWZ";
      };

      xdg.configFile = {
        "Yubico/u2f_keys".source = ./Yubico/u2f_keys;
      };
    };

    users.users.${putquo}.extraGroups = [ "libvirtd" ];
  };
}
