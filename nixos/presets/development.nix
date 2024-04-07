{ config, lib', pkgs, ... }: with lib'; templated.preset "development" {
  inherit config;
  whenEnabled = {
    environment.systemPackages = with pkgs; [
      difftastic
      fd
      fzf
      just
      jq
      poppler
      ripgrep
      theme-sh
      unar
    ];
    virtualisation.podman.enable = true;
  };
}
