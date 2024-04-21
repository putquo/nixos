{ config, lib', ... }: with lib'; templated.preset "kde" {
  inherit config;
  whenEnabled = {
    services.desktopManager.plasma6.enable = true;
  };
}
