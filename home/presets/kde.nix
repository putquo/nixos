{ config, lib', pkgs, ... }: with lib'; templated.preset "kde" {
  inherit config;
  whenEnabled = {
    programs.firefox.profiles.default.extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      plasma-integration
    ];
  };
}
