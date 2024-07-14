{ ... }@_haumeaArgs:
{ pkgs, ... }@_nixosModuleArgs: {
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
}
