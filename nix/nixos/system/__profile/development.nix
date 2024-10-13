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

  nix.settings.substituters = [
    "https://devenv.cachix.org"
    "https://helix.cachix.org"
  ];
  nix.settings.trusted-public-keys = [
    "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
    "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
  ];

  virtualisation.podman.enable = true;
}
