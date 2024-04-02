{ config, lib', ... }: with lib'; templated.preset "development" {
  inherit config;
  whenEnabled = {
    virtualisation.podman.enable = true;
  };
}
