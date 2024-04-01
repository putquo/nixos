{ config, lib', pkgs, ... }:
with lib';
templated.preset "kde" {
  inherit config;
  whenEnabled = {
    programs.firefox.profiles.default.extensions =
      with pkgs.nur.repos.rycee.firefox-addons;
      [ plasma-integration ];

    services.darkman.darkModeScripts.kde = ''
      /usr/bin/env -S lookandfeeltool -a org.kde.breezedark.desktop
    '';
    services.darkman.lightModeScripts.kde = ''
      /usr/bin/env -S lookandfeeltool -a org.kde.breeze.desktop
    '';
  };
}
